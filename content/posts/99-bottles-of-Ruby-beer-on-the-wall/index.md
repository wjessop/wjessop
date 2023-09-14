---
title: 99 bottles of Ruby beer on the wall
date: 2006-07-05T18:32:24Z
draft: false
tags: [Ruby, programming]
summary: 99 bottles of beer codegolf
category: ""
type: Post
---

A while back a friend and I had a 99 bottles of beer on the wall one-liner competition in [Ruby](http://ruby-lang.org/ "Ruby"). I just found this in my home directory and so am claiming it as my entry:

`def b(c)"#{c} bottle#{c>1?"s":""} of beer on the wall"end;99.downto(1){|x|$>0?x-1:99)}.`

It weighs in at a hefty 206 characters and I know it is possible to get it smaller than this, but it is way too much of a time-sink for me to try.
