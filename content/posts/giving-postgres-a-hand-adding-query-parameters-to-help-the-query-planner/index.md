---
title: Giving Postgres a handle adding query parameters to help the query planner
date: 2023-10-15T23:49:00+01:00
draft: true
preview: false
tags: ["programming", "postgres", "performance", "tech"]
summary:
description:
category: ""
type: Post
---

# Increasing postgres query performance with additional parameters

There's a lot to take in here so feel free to skip ahead to the "Improving the performance" section if you are getting lost or falling asleep.

In [Buffer analysis and tracking IO timings when using EXPLAIN ANALYSE](/posts/buffer-analysis-when-using-explain-analyse-in-postgres/) I promised to dig deeper into the specifics of the optimisation that we put in place. This post will go into the details, and hopefully give you some more ideas for helping to optimise your queries in the future.

Let's go back and look at the original query, with the query plan it looked something like this (I've removed the buffers data for brevity):

```sql { hl_lines=[23,24,26,27,28] }
EXPLAIN ANALYSE
SELECT
    events.*
FROM
    events
    INNER JOIN activity_logs ON events.activity_log_id = activity_logs.id
WHERE
    activity_logs.user_id = 9372632
    AND events.date in ('2022-12-31', '2023-01-01')
    AND (
      events.event_start IS NOT NULL
      AND events.event_end IS NOT NULL
      AND events.shift_length != 0
      OR events.exception_id IS NOT NULL
    )
ORDER BY
    date ASC,
    events.event_start DESC NULLS LAST;

Sort  (cost=10157.36..10157.37 rows=1 width=166) (actual time=2420.736..2420.737 rows=0 loops=1)
  Sort Key: events.date, events.event_start DESC NULLS LAST
  Sort Method: quicksort  Memory: 25kB
  ->  Nested Loop  (cost=1.13..10157.35 rows=1 width=166) (actual time=2420.731..2420.731 rows=0 loops=1) -- (1)
        ->  Index Scan using index_activity_logs_on_user_id_and_start_and_end on activity_logs  (cost=0.56..325.89 rows=82 width=4) (actual time=2.046..16.946 rows=316 loops=1) -- (2)
              Index Cond: (user_id = 9372632)
        ->  Index Scan using index_events_on_activity_log_id on events  (cost=0.57..119.89 rows=1 width=166) (actual time=7.603..7.603 rows=0 loops=316) -- (3)
              Index Cond: (activity_log_id = activity_logs.id) -- (4)
              Filter: ((date = ANY ('{2022-12-31,2023-01-01}'::date[])) AND (((start IS NOT NULL) AND ("end" IS NOT NULL) AND (shift_length <> '0'::double precision)) OR (exception_id IS NOT NULL))) -- (5)
              Rows Removed by Filter: 18
Planning:
Planning Time: 0.422 ms
Execution Time: 2420.779 ms
```

This query was run on a cold cache. It's not a particularly complex query, but it took 2.4 seconds to run, that's not great in general, but worse for a query that's run as often as this one. At it's peak it ran over 4000 times per minute. So, what can be done to improve performance here? Let's break down the query plan to see what's happening, it's approximately like this:

Step 1

Postgres pulls data on all `activity_logs` that match the condition `activity_logs.user_id = 9372632`, there are 316 rows in total, you can see this in the `rows=316` entry at mark (2) in the query plan above.

```sql
 activity_log_id | user_id
--------------+---------
       310366 |   9372632
       316650 |   9372632
       324602 |   9372632
       330221 |   9372632
       337458 |   9372632
       344498 |   9372632
       352023 |   9372632
       359360 |   9372632
       367422 |   9372632
       374930 |   9372632
<snip 296 rows>
     22069105 |   9372632
     22193550 |   9372632
     22317324 |   9372632
     22447556 |   9372632
     22596124 |   9372632
     22788358 |   9372632
     22881229 |   9372632
     23011303 |   9372632
     23158612 |   9372632
     23307676 |   9372632
```

Step 2

This is where the "Nested Loop" hits. For every row found in Step 1, postgres looks up the `activity_logs.id` entry in the `index_events_on_activity_log_id` index (where I've marked (3) and (4)) and then filters these rows out (5) using the conditions present in the `WHERE` clause. There are 5552 rows in the events table that match the `activity_log_ids` returned in the first step, on average 18 per `activity_log_id` in the nested loop.

Step 3

This is where any data that would be returned will be sent back to the client on the database connection, but in this case there are 0 rows returned.

## Improving the performance

So this query runs for 2.4 seconds and pulls back 25MB (see calculation in the linked post) of data from disk to return 0 rows, that's not great, but even though this is a really simple query, just one join, we can help postgres out, a lot. The way we do this is by knowing that for this query the only `activity_logs` that can be relevant are those that start on or after the activity start date (where the query originates) @start_date, end before the definition of "end_of_week + 1.day" in the class. activity_logs outside that range aren't relevant so this gives us data we can feed back into the query. The new query with the timesheet date constraints (picking some sample dates for the parameters) is:

```sql { hl_lines=[9,10,31] }
EXPLAIN (ANALYSE, BUFFERS)
SELECT
    events.*
FROM
    events
    INNER JOIN activity_logs ON events.activity_log_id = activity_logs.id
WHERE
    activity_logs.user_id = 9372632
    AND activity_logs.event_start <= '2022-12-31' -- New parameter!
    AND '2023-01-08' <= activity_logs.event_end   -- New parameter!
    AND events.date in ('2022-12-31', '2023-01-01')
    AND (
      events.event_start IS NOT NULL
      AND events.event_end IS NOT NULL
      AND events.shift_length != 0
      OR events.exception_id IS NOT NULL
    )
ORDER BY
    date ASC,
    events.event_start DESC NULLS LAST;

Sort  (cost=1491.66..1491.67 rows=1 width=166) (actual time=1.420..1.421 rows=0 loops=1)
  Sort Key: events.event_start DESC NULLS LAST
  Sort Method: quicksort  Memory: 25kB
  Buffers: shared hit=3 read=1
  ->  Nested Loop  (cost=1.13..1491.65 rows=1 width=166) (actual time=1.415..1.415 rows=0 loops=1)
        Buffers: shared hit=3 read=1
        ->  Index Scan using index_activity_logs_on_user_id_and_start_and_end on activity_logs  (cost=0.56..51.70 rows=12 width=4) (actual time=1.414..1.414 rows=0 loops=1)
              Index Cond: ((user_id = 70142) AND (start > '2022-06-18'::date))
              Buffers: shared hit=3 read=1
        ->  Index Scan using index_events_on_activity_log_id on events  (cost=0.57..119.99 rows=1 width=166) (never executed) -- (6)
              Index Cond: (activity_log_id = activity_logs.id)
              Filter: ((((start IS NOT NULL) AND ("end" IS NOT NULL) AND (shift_length <> '0'::double precision)) OR (exception_id IS NOT NULL)) AND (date = '2023-01-18'::date))
Planning:
  Buffers: shared hit=150
Planning Time: 0.430 ms
Execution Time: 1.461 ms
```

This is also on a cold cache. So what's the difference here? The obvious thing is end result of the execution time, 1.5ms instead of 2400ms, that's 0.06% of the time taken, but what's the breakdown of where we saved time? If you follow the overall plan laid out earlier you can see that compared to Step 1. Postgres is still trying to pull back timesheet rows out of the `activity_logs` table, it's even using the same index, but it's added a `activity_logs.event_start` condition to the index lookup, and it return 0 rows, compared to the 316 rows returned by the previous query. Because Postgres has pulled back no rows here it doesn't need to run the loop in Step 2 316 times at all, see mark (6). This is great, not running code at all is the best optimisation we can do as after all, no code is faster than no code. This new query also pulled back far less data, 8k vs 25MB greatly reducing the IO load on the database server, which was what got this query noticed in the first place.

Some of you might have noticed that we've picked a couple of fairly old `user_ids` here (9372632, 70142) that may well not have many recent activity_logs or events, and that's true, these users only have `activity_logs` that go up to October/November 2021, but they were picked for a reason. They're pretty close to the worst case and it's not like these are much of an outlier, there are `user_ids` going down to 18 that have activity_logs in the period we're testing here. Often when testing it's easier to see the difference you're making when you pick the worst performing dats, as long as you test it on a range of data to verify the results on less "troublesome" data.

The ultimate proof though is when it goes to production which is when we finally get to see if the changes we made have helped. It's important to track the changes you make to production because for all the testing on staging or locally that you do there could still be something about the volume or shape of data, different memory or configuration parameters on production that ultimately cause your new query to run slower. It doesn't happen often, but it does happen. Thankfully PGAnalyse shows us that this optimisation was successful, it's not dissapeared from the problem queries list completely:


picture.


## Some final notes

### What if there's no well defined start and end date?

Here we used both a start and end date to limit the data, and these dates are tightly scoped by the shift/timesheet relationship, but that's not always possible. The key here was limiting the scope on the activity_logs table, so any field you can add as a parameter will give the query planner more to go off. Previously I've picked a sensible but arbitrary cutoff date for queries (in an SMS messaging system only looking for message threads newer than n months when handling incoming messages for instance). This is related to the next point:

### Add more conditions if you can

There's a good rule of thumb which is to add as many parameters to the query as you can to give the query planner more to work on. For instance status on activity_logs isn't indexed, but a condition on that field could filter rows in Step 1, potentially cutting down the nested loops. If you don't add a condition with a parameter then Postgres can't use it. This doesn't always work, Postgres can pick the wrong execution plan, but that's pretty rare.

An example of this, though we added a start and end date to the optimised query above you can see from the query plan that postgres only queried the timesheet index for the start date:

    Index Cond: ((user_id = 70142) AND (start > '2022-06-18'::date))

That's OK, we can leave the end data in, postgres might be able to make use of it later for different data. In fact, checking a different user_id now I can see that postgres /has/ used the end date on the index lookup in this instance (7):

                                                                                                 QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Repeated testing shows this additional use of the end query parameter to cut about 0.04ms from the query. It's not a lot, but we may as well, it's free!

### Design query scope into the product early

If you can, think about how to limit data returned at the product design stage. It's easy to forget when you're first starting out with a feature that the data will (hopefully) be acumulating for years to come (the oldest shift was created on 2012-10-14). Consider building in constraints where possible early, such as "last 30 days of widget_sales" rather than just "List all widget_sales". You set the expectations of users early, and it's easier to expand the conditions later than it is to constrict them.

# Size /and/ shape of data is important

When you're optimising queries the amount of data you are testing against matters, this is the more obvious thing, but "shape" matters too. For example low cardinality in a table that in production has high cardinality. If you're testing on production data this isn't an issue, the data you're testing against /is/ the data you're going to be running the query against eventually, but if you're using generated data (for instance if production data is siloed and unavailable) then generating enough data that is as closely matched in it's shape and relationship as production is important.
