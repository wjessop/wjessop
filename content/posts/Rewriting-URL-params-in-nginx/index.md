---
title: Rewriting URL params in nginx
date: 2009-03-07T14:30:37Z
draft: false
tags: [tech]
summary: Re-writing query params from one format into another is pretty simple.
description: Re-writing query parameters in Nginx is pretty simple with this small config change.
category: ""
type: Post
---

I came across this problem recently, a customer was moving to Ruby on Rails from another framework/language (.NET I think) and needed to re-write a bunch of URLs. Some needed the query parameters rewriting too. One example was rewriting the old search path, so the old URL:

`http://somedomain.com/OldSearchPath.aspx?qry=things&page=4`

would become:

`http://somedomain.com/search?query=things&page=4`

This should be fairly simple except for the _qry_ parameter needed to be changed to _query_. A bit of googling didn't turn up much but with some experimentation I came up with this using the pre-populated nginx $args variable:

```
location /OldSearchPath.aspx {
  if ($args ~* qry=(.+)) {
    set $args query=$1;
  }
}
rewrite ^.+$ /search redirect;
```

It even leaves the other parameters intact, so the pagination will still work.
