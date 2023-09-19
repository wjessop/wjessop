---
title: Buffer analysis when using EXPLAIN ANALYSE in Postgres
date: 2023-09-15T23:49:00+01:00
draft: false
preview: false
tags: ["programming", "postgres", "performance", "tech"]
summary: Many people are familiar with Postgres' `EXPLAIN` and `EXPLAIN ANALYSE` reports, but there are a couple of useful options available when running them that aren't always commonly known that can help you identify and fix potential problem areas. In this article I will go through how I used the `BUFFERS` report to help massively reduce the IO demands of a problem query, speeding up the query by nearly 1208 times.
description: The BUFFERS option to Postgres' EXPLAIN command can help you work out where queries are using lots of IO. learn how to use this to optimize your SQL.
category: ""
type: Post
---

Many people are familiar with running `EXPLAIN` and `EXPLAIN ANALYSE` to diagnose Postgres performance issues, but there are a couple of useful options available when running these reports that aren't always commonly known that you might find useful. The first of these is the `BUFFERS` option.

In this article I will explain how to measure buffer usage in Postgres using the `BUFFERS` option, and how I used it to help verify that a query optimization to massively reduce the IO demands of a problem query had worked.

## The BUFFERS option

The `BUFFERS` option can be used when running a simple `EXPLAIN`, but really comes into it's own when running an `EXPLAIN ANALYSE`. In summary `BUFFERS` will give you data on the buffer usage of a query. The postgres docs give a good description of what the data you get tells you:

> Include information on buffer usage. Specifically, include the number of shared blocks hit, read, dirtied, and written, the number of local blocks hit, read, dirtied, and written, the number of temp blocks read and written, and the time spent reading and writing data file blocks and temporary file blocks (in milliseconds) if track_io_timing is enabled. A hit means that a read was avoided because the block was found already in cache when needed. Shared blocks contain data from regular tables and indexes; local blocks contain data from temporary tables and indexes; while temporary blocks contain short-term working data used in sorts, hashes, Materialize plan nodes, and similar cases. The number of blocks dirtied indicates the number of previously unmodified blocks that were changed by this query; while the number of blocks written indicates the number of previously-dirtied blocks evicted from cache by this backend during query processing. The number of blocks shown for an upper-level node includes those used by all its child nodes. In text format, only non-zero values are printed. It defaults to FALSE.

- https://www.postgresql.org/docs/current/sql-explain.html

Cutting down buffer usage can be a great way to decrease IO resource usage for a query.

## An example

Let's look at an example query. This is similar to one that I optimized for a client and the exact SQL/data structure isn't important. Note the `EXPLAIN (ANALYSE, BUFFERS)` line at the start of the query:

```sql { hl_lines=[21,23,26,31]}
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
  Buffers: shared hit=1166 read=3117 -- (0)
  ->  Nested Loop  (cost=1.13..10157.35 rows=1 width=166) (actual time=2290.757..2290.758 rows=0 loops=1)
        Buffers: shared hit=1166 read=3117  -- (1)
        ->  Index Scan using index_activity_logs_on_user_id_and_event_start_and_event_end on activity_logs  (cost=0.56..325.89 rows=82 width=4) (actual time=0.018..14.964 rows=315 loops=1)
              Index Cond: (user_id = 83463)
              Buffers: shared hit=33 read=116 -- (2)
        ->  Index Scan using index_events_on_activity_logs_id on events  (cost=0.57..119.89 rows=1 width=166) (actual time=7.221..7.221 rows=0 loops=315)
              Index Cond: (activity_logs_id = activity_logs.id)
              Filter: ((((event_start IS NOT NULL) AND (event_end IS NOT NULL) AND (duration <> '0'::double precision)) OR (exception_id IS NOT NULL)) AND (date = '2022-12-04'::date))
              Rows Removed by Filter: 11
              Buffers: shared hit=1133 read=3001 -- (3)
Planning:
  Buffers: shared hit=146
Planning Time: 0.427 ms
Execution Time: 2290.813 ms
```

There's a lot to take in here, but the difference you're looking for compared to a regular `EXPLAIN` output are the lines that start with `Buffers: …` I've marked them all in the explain output above with the labels `(0)`, `(1)`, `(2)` and `(3)`. They look like this:

	Buffers: shared hit=1166 read=3117

This line is telling us that **1166 blocks were satisfied by the shared cache**, and **3117 blocks were read from disk**.

<aside class="thought">
<h3>What is a block?</h3>

Blocks are chunks of data of a certain size. [The size is configurable, but is typically left at the default of 8192 bytes](https://www.postgresql.org/docs/current/runtime-config-preset.html). You can check this on your server:

```sql
=> show block_size;
 block_size
------------
 8192
(1 row)
```
</aside>

<aside class="thought">
<h3>Shared cache vs disk?</h3>

Postgres maintains a cache in memory, the "shared buffer cache", where it stores data that it has fetched from disk for faster retrieval later. Fetches from this store are massively faster than fetches from disk when the cache is "missed".

Postgres doesn't just fetch data from either the cache or disk that *it will return*, it fetches data from both stores that it needs *to determine the rows that it will return*. For an unoptimized query it is possible for postgres to fetch a significant amount of data that it never sends to the client. Minimising the data you fetch from disk to determine your eventual result set that is then discarded is key to optimizing the IO usage of your queries.

You can find the [docs for the shared_buffers setting here](https://www.postgresql.org/docs/current/runtime-config-resource.html).
</aside>

Taking this block size value and going back to our Buffers report:

	Buffers: shared hit=1166 read=3117

We can see here that **1166 blocks (9,551,872 bytes) were provided by the shared cache**, but **3117 blocks (25,534,464 bytes) had to be read from disk**. This was the data reported from the location I marked with `(0)`, but there are other locations too, marked with `(1)`, `(2)` and `(3)`. The `EXPLAIN` command breaks down buffer usage by section, and the report is cumulative, so the buffer usage reported in sections `(2)` and `(3)` when added together equal the buffer usage reported at the parent node in section `(1)`, and so on.

The breakdown by section means that you can see where the buffer usage is highest and target your optimization in that area. For instance in the example query you can see that more than 95% of the buffer usage happens in section `(3)`, the `Index Scan using index_events_on_activity_logs_id` and so this area would be a good place to start investigating optimizations.

<aside class="thought">
<h3>Why does it matter if we go to disk instead of the shared cache in memory?</h3>
Disk (SSD) read speeds are substantially slower than reads from memory, in the region of 450 MB/s for an SSD compared to around 13,000 MB/s for memory (varying depending on the specific hardware). The "Latency numbers every programmer should know" table, originally by <a href="http://norvig.com/21-days.html#answers">Peter Norvig</a> shows the difference well.


	L1 cache reference ......................... 0.5 ns
	Branch mispredict ............................ 5 ns
	L2 cache reference ........................... 7 ns
	Mutex lock/unlock ........................... 25 ns
	Main memory reference ...................... 100 ns
	Compress 1K bytes with Zippy ............. 3,000 ns  =   3 µs
	Send 2K bytes over 1 Gbps network ....... 20,000 ns  =  20 µs
	SSD random read ........................ 150,000 ns  = 150 µs
	Read 1 MB sequentially from memory ..... 250,000 ns  = 250 µs
	Round trip within same datacenter ...... 500,000 ns  = 0.5 ms
	Read 1 MB sequentially from SSD ...... 1,000,000 ns  =   1 ms (Assuming ~1GB/sec SSD)
	Disk seek ........................... 10,000,000 ns  =  10 ms
	Read 1 MB sequentially from disk .... 20,000,000 ns  =  20 ms
	Send packet CA->Netherlands->CA .... 150,000,000 ns  = 150 ms
</aside>


Before we get into what this buffers data in the explain output is useful for, let's run the explain again with the same parameters to see what happens:

```sql {hl_lines=[21]}
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

Sort  (cost=10157.36..10157.37 rows=1 width=166) (actual time=6.150..6.151 rows=0 loops=1)
Sort Key: events.event_start DESC NULLS LAST
Sort Method: quicksort  Memory: 25kB
Buffers: shared hit=3577
->  Nested Loop  (cost=1.13..10157.35 rows=1 width=166) (actual time=6.145..6.145 rows=0 loops=1)
			Buffers: shared hit=3577
			->  Index Scan using index_activity_logs_on_user_id_and_event_start_and_event_end on activity_logs  (cost=0.56..325.89 rows=82 width=4) (actual time=0.020..0.350 rows=315 loops=1)
						Index Cond: (user_id = 83463)
						Buffers: shared hit=45
			->  Index Scan using index_events_on_activity_logs_id on events  (cost=0.57..119.89 rows=1 width=166) (actual time=0.018..0.018 rows=0 loops=315)
						Index Cond: (activity_logs_id = activity_logs.id)
						Filter: ((((event_start IS NOT NULL) AND (event_end IS NOT NULL) AND (duration <> '0'::double precision)) OR (exception_id IS NOT NULL)) AND (date = '2022-12-04'::date))
						Rows Removed by Filter: 11
						Buffers: shared hit=3532
Planning:
Buffers: shared hit=148
Planning Time: 0.445 ms
Execution Time: 6.198 ms
```

What you can see here from the buffer data is that Postgres no-longer has to go to disk. The data that was read in the previous query is now in the shared cache so we're fetching all our data from memory, there is no `read=nnnn` reported:

	Buffers: shared hit=3577

This results in a much faster query time, the original query took 2291ms and the cached one 6ms ⚡️. Unfortunately even though this query was much faster the second time round we don't always have the luxury of running queries that are cached so we often need to optimize for the cold cache situation, plus if we can reduce the buffers usage of the query we can make it even faster and less resource intensive still, plus if we can trim the data pulled from the shared cache down too that will also help with performance.

So, what can we use this information for? The query I'm using in the example is similar to one I optimized for a client that was the highest IO usage of all queries on their production server at nearly 16% if all IO used.

When we're trying to improve the performance of this query we can make it faster, and that would be great by itself and is often the main goal of a performance optimization, but we really want to actually **verify that any changes we make have reduced the IO** which is the larger problem here; we really want to stick to the performance optimization mantra of "measure, change, measure". **With the buffers data we can see what difference we're making**, if any, to the performance of the query as we change it. Here's the same query on a cold cache but with an optimization:

```sql {hl_lines=[10]}
EXPLAIN (ANALYSE, BUFFERS)
SELECT
	events.*
FROM
	events
	INNER JOIN activity_logs ON events.activity_logs_id = activity_logs.id
WHERE
	activity_logs.user_id = 348927
	AND events.date in ('2022-12-04')
	AND activity_logs.event_start > '2022-12-10'
	AND (events.event_start IS NOT NULL
		AND events.event_end IS NOT NULL
		AND events.duration != 0
		OR events.exception_id IS NOT NULL)
ORDER BY
	date ASC,
	events.event_start DESC NULLS LAST;

Sort  (cost=1491.66..1491.67 rows=1 width=166) (actual time=1.855..1.856 rows=0 loops=1)
  Sort Key: events.event_start DESC NULLS LAST
  Sort Method: quicksort  Memory: 25kB
  Buffers: shared hit=2 read=2
  ->  Nested Loop  (cost=1.13..1491.65 rows=1 width=166) (actual time=1.850..1.851 rows=0 loops=1)
        Buffers: shared hit=2 read=2
        ->  Index Scan using index_activity_logs_on_user_id_and_event_start_and_event_end on activity_logs  (cost=0.56..51.70 rows=12 width=4) (actual time=1.850..1.850 rows=0 loops=1)
              Index Cond: ((user_id = 348927) AND (event_start > '2022-12-10'::date))
              Buffers: shared hit=2 read=2
        ->  Index Scan using index_events_on_activity_logs_id on events  (cost=0.57..119.99 rows=1 width=166) (never executed)
              Index Cond: (activity_logs_id = activity_logs.id)
              Filter: ((((event_start IS NOT NULL) AND (event_end IS NOT NULL) AND (duration <> '0'::double precision)) OR (exception_id IS NOT NULL)) AND (date = '2022-12-04'::date))
Planning:
  Buffers: shared hit=148
Planning Time: 0.427 ms
Execution Time: 1.897 ms
```

The specific optimization isn't relevant here (it's the addition of the condition `AND activity_logs.event_start > '2022-12-10'` which I highlighted), I'll talk about that in another article, but what you can see if you compare to the earlier uncached query plan is that the "Execution Time" is far smaller at 1.9ms, down from 2290ms, but also **the amount of data fetched from disk (the "read" buffers) is far smaller too** at 2 blocks, or 16,384 bytes, down from 25,534,464 bytes before.

	Buffers: shared hit=1166 read=3117

vs:

	Buffers: shared hit=2 read=2

That's a reduction of over 24 MB, a huge IO amount of IO to trim from the query! With this data we have a pretty good idea that we've made a significant difference to the IO problem.

<aside class="thought">
<h3>The changing user_id and statistical comparison</h3>

<p>You might have noticed that the ID of the <code>activity_logs.user_id</code> changed in that last query, and be wondering if the different data returned by the query will alter it's performance characteristics, and that would be correct. Ideally it would be possible to flush the shared cache between tests to make the test fair, but that's hard to do with Postgres. To do so you would need to shut down the Postgres server process, dump linux's cache, and restart Postgres. That's fairly cumbersome so instead what I do is to run the original and changed queries multiple times using different IDs to get a statistical comparison of the effect the change has.
</p>
</aside>

## Conclusion

At scale IO can be a significant performance bottleneck for databases and optimizing problem queries that cause large amounts of IO can yield significant benefits. Adding the `BUFFERS` option when using `EXPLAIN ANALYSE` can give you a great way to identify problem areas of a query, and to verify when you're done that you've actually solved the issue.

If you've found this interesting you might be interested in second part of this article, [Measuring IO timings when using EXPLAIN ANALYSE in Postgres](/posts/measuring-io-timing-for-postgres-explain-analyse).
