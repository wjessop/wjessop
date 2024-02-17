---
title: Finding Postgres rows too large for BTree indexes
date: 2024-02-17T17:25:00+00:00
draft: false
preview: true
tags: ["programming", "postgres", "performance", "tech"]
summary: How I found and fixed the rows in our database that exceeded the BTree index size, preventing our migration to AlloyDB.
description: A Ruby program to find rows in a Postgres database that are too large for BTree indexes.
category: ""
type: Post
---

We are currently migrating our main application database from AWS Aurora Postgres to Google AlloyDB Postgres (it's a cost decision) and I'm using Google's database Migration tool to do the work. At some point last week the migration failed on Google's side with an error:

    index row size 2712 exceeds btree version 4 maximum 2704 for index index_name_column_name

I've not seen this before, but it was easy to find the problem rows affecting this specific index/column:

```sql
SELECT * FROM table_name WHERE octet_length(column_name) > 2704
```

Simple enough, out popped 5 rows where the data in `column_name` was too large. This data was junk so NULLing it out fixed the bad data I knew about, but I wanted to make sure that there weren't more indexes with this issue, replicating our database to AlloyDB takes time and egress cost from AWS so fixing any known issues before we do this makes a lot of sense. To do this I wrote this Ruby program. The program scans through all column combinations for each table where the combined data _could_ be too large for an index and outputs a warning if the data it finds _is_ too large, allowing you to then run a select to get the specific data that caused the problem.

```ruby
# This code is MIT licensed

require "pg"

dsn = ARGV[0]
conn = PG.connect(dsn)

# So our postgres array gets converted to a Ruby array
conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn)

# I've seen various figures for the maximum index entry size including 2712
# bytes, 2713 bytes, and block_size/3 (which for the default block size of 8 kB
# is ~2730 bytes), however 2704 bytes is the figure given by the error from
# AlloyDB, so is the one we're using here.
#
# You might need to change this value if you are using a different block size.
max_index_size = 2704

# Create a cache for column size lookups. Column sizes will be in two types:
#
#   1. "static" types, eg. int. These won't change no-matter what data is stored
#      in them so we can just return the size for the type, eg. int => 4 bytes.
#   2. "dynamic" types, eg. text. The octet_length of these will change
#      depending on what is stored in them, and so we can't store a fixed
#      integer byte size and need to scan the database to find the max size. As
#      such rather than storing a fixed size we will store the query to find the
#      max length.
#
# We cache the values as we will be doing the opereration per index, and for the
# same table a column can appear in multiple indexes, but the static/dynamic
# nature of the column will not changed so we can save a little work by cacheing
# the result.
@column_type_length_cache = {}

# Query to find all indexes in the 'public' schema that contain columns that are
# "dynamic", eg. text or jsonb expressions. Indexes that contain "static" data
# types, eg. integer alone aren't interesting as it's unlikely that you will
# exceed the max BTree index entry size with things like UUIDs or integers
# alone.
query_indexes = <<~SQL
  SELECT
    t.relname AS table_name,
    ix.relname AS index_name,
    ARRAY_AGG(a.attname) AS column_name,
    CASE
        WHEN i.indexprs IS NOT NULL THEN pg_get_expr(i.indexprs, i.indrelid)
        ELSE NULL
    END AS index_expression
  FROM
    pg_class t
    JOIN pg_catalog.pg_index i ON t.oid = i.indrelid
    JOIN pg_catalog.pg_class ix ON ix.oid = i.indexrelid
    JOIN pg_attribute a ON a.attrelid = t.oid
      AND a.attnum = ANY (i.indkey)
    JOIN pg_am am ON am.oid = ix.relam
  WHERE
    i.indexrelid IN (
      -- Select any indexes that contain at least one field type we care about,
      -- excluding field types that we know, when used alone, will not be larger
      -- than an index entry, unless you are doing something especially fruity.
      SELECT
        distinct(c.oid)
      FROM
      pg_catalog.pg_class c
        JOIN pg_catalog.pg_index i ON c.oid = i.indexrelid
        JOIN pg_catalog.pg_namespace ns ON c.relnamespace = ns.oid
        JOIN pg_catalog.pg_attribute a ON a.attrelid = c.oid
      WHERE
        relkind = 'i'
        AND indisprimary = FALSE
        AND ns.nspname = 'public'
        AND a.atttypid NOT IN (
          16,   -- boolean
          20,   -- bigint
          21,   -- smallint
          23,   -- integer
          1082, -- date
          1114, -- timestamp without timezone
          2950  -- uuid
        )
      )
    AND am.amname = 'btree' -- I am only concerned about btree types as that was the error we are dealing with
  GROUP BY table_name, index_name, index_expression
SQL

indexes_result = conn.exec(query_indexes).map(&:values)

def column_octet_length_query(conn, column)
  "max(octet_length('#{conn.quote_ident(column)}'))"
end

def expression_octet_length_query(expression)
  "max(octet_length(#{expression}))"
end

def fetch_column_type_length(conn, table_name, column_name)
  cache_key = "#{table_name}_#{column_name}"

  # We can have multiple indexes on the same table that reference the same
  # column so let's cache the lookups for a column
  @column_type_length_cache[cache_key] ||= begin
    query = <<~SQL
      SELECT
        a.atttypid,
        t.typlen
      FROM pg_attribute a
      JOIN pg_type t ON a.atttypid = t.oid
      JOIN pg_class c ON a.attrelid = c.oid
      WHERE c.relname = $1 AND a.attname = $2
    SQL

    result = conn.exec_params(query, [table_name, column_name])
    typlen = result.first['typlen'].to_i

    typlen.positive? ? typlen : column_octet_length_query(conn, column_name)
  end
end

indexes_result.each do |table_name, index_name, column_names, index_expression|
  index_expression ||= ""
  begin
    regular_column_size_queries = column_names.map { |cn| fetch_column_type_length(conn, table_name, cn) }
    expression_size_queries = index_expression.split(", ").map { |e| expression_octet_length_query(e) }
    all_size_queries_string = (regular_column_size_queries + expression_size_queries).join(' + ')
    compound_size_query = "SELECT #{all_size_queries_string} AS max_size FROM #{conn.quote_ident(table_name)}"

    max_size = conn.exec(compound_size_query).first["max_size"].to_i

    if max_size > max_index_size
      puts "\033[31mWARNING: #{table_name} (#{index_name}): #{column_names.join(', ')}: Maximum Size: #{max_size} bytes exceeds the max index size\033[0m"
    end
  rescue PG::InsufficientPrivilege
    # We have some tables that I can't access with the user this runs as, but I don't care about them.
    puts "Permission denied for table #{table_name}"
  end
end

conn.close
```

You run it using:

    $ ruby script_name.rb your_postgres_dsn

It may take quite a lot of time to run, it effectively sequential scans all of your tables where there is a row that could be larger than the allowed row size for a BTree index, and as such you may want to run it against a replica and/or out of hours to avoid production impact, but other than that it's safe. For us it did find about a hundred rows in another table that were too large for the index allowing us to fix these before re-starting the migration process.

    WARNING: some_other_table (some_index_name_idx): user_id, email, phone, approved: Maximum Size: 28586 bytes exceeds the max index size

Yeah, some people had suspiciously long emails. We're adding size constraints on the columns that were missing them now. If you get a warning like this then you can craft a query to find the problem rows, eg.

```sql
SELECT * FROM some_other_table WHERE octet_length(email) + octet_length(phone) > 2704
```

Some highlights:

- The program will sum the octet_length of all fields in an index, so if you have an index with two columns in it and it's only the sum of the octet_lengths that will push the row over the BTree row size this program will still find the issue.
- The program prunes indexes and tables where there are no indexes that could be large enough to be over the limit, effectively cutting the number of table scans it needs to do. If you've got an index with 677 int fields in it then the assumption this relies on will break down, but I've never seen that, and never want to.

Some caveats:

- Table names and column names are escaped, but don't run this if you have untrusted third-parties who can control any expressions you have in your database. For instance if you're indexing into JSON with a user supplied key, eg. `(comments ->> 'user_supplied_value'::text)`. You're probably not doing this, I've never seen it, but just be aware.
- This program finds rows that violate the size constraints, it doesn't find situations where a row _could_ violate the size limit if you were to put in the maximum amount of data allowed by the types.
- I believe this program works if you are indexing into multiple JSONB fields in one index, but I've not tested it with those as we only have indexes into a single JSONB field, eg:

      "index_name" btree (some_id, (comments ->> 'some_key'::text))

Please let me know if you run this and have success and/or issues, or if you come up with a more efficient way of doing the same thing.
