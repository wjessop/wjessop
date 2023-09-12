---
title: Testing Github commit hook one liners
date: 2014-06-09T13:24:11
draft: false
tags: [github, Ruby, programming, tech]
summary: A couple of ruby one-liners for dumping out the content of a github commit hook payload
category: ""
type: Post
---

A couple of ruby one-liners for dumping out the content of a github commit hook payload:

For hooks that use type **application/json**:

```sh
$ ruby -rpp -rjson -rsinatra -e 'set :port, 8000; post "/*" do; pp JSON(request.body.read); end'
```

For hooks that use type **application/x-www-form-urlencoded**:

```sh
$ ruby -rpp -rjson -rsinatra -e 'set :port, 8000; post "/*" do; pp JSON(params[:payload]); end'
```
