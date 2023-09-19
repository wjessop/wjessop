---
title: Measuring IO timings when using EXPLAIN ANALYSE in Postgres
date: 2023-09-19T23:21:00+01:00
draft: false
preview: false
tags: ["programming", "postgres", "performance", "tech"]
summary: A followup to my post about using `BUFFERS` with `EXPLAIN ANALYSE` I talk about the IO timing tracking option in Postgres which can give you an exact breakdown of how long each part of a query took in milliseconds of IO time.
description: Using IO timing tracking with EXPLAIN ANALYSE can show you exactly how long your queries spent on IO.
category: ""
type: Post
---

In [an earlier post about using `BUFFERS` with `EXPLAIN ANALYSE`](/posts/buffer-analysis-when-using-explain-analyse-in-postgres) I mentioned that there were a couple of options to `EXPLAIN ANALYSE` that were not widely known, but I only talked about one, the `BUFFERS` option. In this article I will dig into that second option; IO timing tracking.

## IO timing tracking

The second tweak to the default `EXPLAIN` usage is using IO timing tracking. You can set this per session:

    set track_io_timing = on;

As usual [the Postgres docs do a thorough job explaining what this setting does](https://www.postgresql.org/docs/current/runtime-config-statistics.html):

> Enables timing of database I/O calls. This parameter is off by default, as it will repeatedly query the operating system for the current time, which may cause significant overhead on some platforms. You can use the pg_test_timing tool to measure the overhead of timing on your system. I/O timing information is displayed in pg_stat_database, in the output of EXPLAIN when the BUFFERS option is used, in the output of VACUUM when the VERBOSE option is used, by autovacuum for auto-vacuums and auto-analyzes, when log_autovacuum_min_duration is set and by pg_stat_statements. Only superusers and users with the appropriate SET privilege can change this setting.

However simply put for our use case if you turn this setting on then when you run an `EXPLAIN (ANALYSE, BUFFERS)` you will get the time in milliseconds that the IO operations in each part of your query took to perform, for example using one of the queries from the previous post:

```sql {hl_lines=[22,25,29,35]}
EXPLAIN (ANALYSE, BUFFERS)
SELECT
	events.*
FROM
	events
	INNER JOIN activity_logs ON events.activity_logs_id = activity_logs.id
WHERE
	activity_logs.user_id = 83463
	AND events.date in ('2022-12-04')
	AND (events.event_start IS NOT NULL
		AND events.event_end IS NOT NULL
		AND events.duration != 0
		OR events.exception_id IS NOT NULL)
ORDER BY
	date ASC,
	events.event_start DESC NULLS LAST;

	Sort  (cost=10157.36..10157.37 rows=1 width=166) (actual time=2290.762..2290.763 rows=0 loops=1)
  Sort Key: events.event_start DESC NULLS LAST
  Sort Method: quicksort  Memory: 25kB
  Buffers: shared hit=1166 read=3117
  I/O Timings: read=3221.979
  ->  Nested Loop  (cost=1.13..10157.35 rows=1 width=166) (actual time=2290.757..2290.758 rows=0 loops=1)
        Buffers: shared hit=1166 read=3117
        I/O Timings: read=3221.979
        ->  Index Scan using index_activity_logs_on_user_id_and_event_start_and_event_end on activity_logs  (cost=0.56..325.89 rows=82 width=4) (actual time=0.018..14.964 rows=315 loops=1)
              Index Cond: (user_id = 83463)
              Buffers: shared hit=33 read=116
              I/O Timings: read=137.986
        ->  Index Scan using index_events_on_activity_logs_id on events  (cost=0.57..119.89 rows=1 width=166) (actual time=7.221..7.221 rows=0 loops=315)
              Index Cond: (activity_logs_id = activity_logs.id)
              Filter: ((((event_start IS NOT NULL) AND (event_end IS NOT NULL) AND (duration <> '0'::double precision)) OR (exception_id IS NOT NULL)) AND (date = '2022-12-04'::date))
              Rows Removed by Filter: 11
              Buffers: shared hit=1133 read=3001
              I/O Timings: read=3083.993
Planning:
  Buffers: shared hit=146
Planning Time: 0.427 ms
Execution Time: 2290.813 ms
```

As with the `BUFFERS` option the timings are cumulative at each node in the hierarchy of the explain output.

This isn't something that I've personally found particularly useful, I suspect it might be useful when diagnosing slow fetches if you're storing data on different backend data stores across tables, but it's interesting to see.
