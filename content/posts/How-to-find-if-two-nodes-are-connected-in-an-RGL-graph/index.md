---
title: How to find if two nodes are connected in an RGL graph
date: 2015-09-25T16:39:53Z
draft: false
tags: [programming, ruby, tech]
summary: I'm experimenting with graphs and I needed to find out if two nodes in an rgl graph were connected
category: ""
type: Post
---
Say you have a graph like this:

{{< figure src="images/graph.jpg" title="A simple graph" class="full" alt="a simple graph">}}

How do you find out if there is a path between any of the two nodes? By using a breadth-first search:

```ruby
require 'rgl/implicit'
require 'rgl/traversal'

vertices = ["one", "two", "three"]

g = RGL::ImplicitGraph.new do |g|
  g.vertex_iterator { |b| vertices.map{|v| b.call(v) } }
  g.adjacent_iterator { |x, b| b.call( vertices[(vertices.index(x) - 1).abs] ) }
  g.directed = true
end

t = g.bfs_search_tree_from("one")

puts t.has_vertex?("two")   # true
puts t.has_vertex?("three") # false
```
