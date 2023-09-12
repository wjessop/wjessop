---
title: Creating BERT dicts in Go
date: 2013-02-10T02:09:06Z
draft: false
tags: ["Go", "programming"]
summary: BERT is an interesting data serialisation format, I learn how to create them in Go.
category: ""
type: Post
---

I’ve been learning Go recently and have written a program to connect to an existing service (written in Ruby) that sends and receives messages serialised as [BERT](http://bert-rpc.org/) terms.

I’m posting this partly because I had quite a lot of fun figuring it out and partly to document creating BERT dicts in Go should anyone else need to do this in the future and hit the same issues I did.

## Why BERT?

I'm a big fan of BERT. It’s compact, flexible, and there are good libs available for serialisation/de-serialisation. So far I’ve exclusively been using the [bert gem](https://github.com/mojombo/bert) (written by Tom Preston-Werner, author of the BERT spec).

## Creating BERT dicts

One of the great features of BERT is the complex types it supports, including dicts. The equivalent to a dict in Ruby would be a hash, in Go a map. They are really simple to create in Ruby:

```ruby
require 'bert'
BERT.encode({"key" => "val"})
=> "\x83h\x03d\x00\x04bertd\x00\x04dictl\x00\x00\x00\x01h\x02m\x00\x00\x00\x03keym\x00\x00\x00\x03valj"
```

We can pull this apart and see exactly what the bert gem did to our data. Let's dump the string to an array of 8-bit unsigned integers:

```ruby
BERT.encode({"key" => "val"}).unpack("C*")
=> [131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 109, 0, 0, 0, 3, 107, 101, 121, 109, 0, 0, 0, 3, 118, 97, 108, 106]
```

It’s hard to see exactly what happened, but with the BERT docs and the [erlang External Term Format docs](http://erlang.org/doc/apps/erts/erl_ext_dist.html) we can see how the hash got encoded.

```
magic| tuple |  atom   |       bert     |            |    dict        |  list 1 elem    |      list      |   atom  |      key      |   atom  |      |  val       | nil | nil
131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 108, 0, 0, 0, 2, 100, 0, 3, 107, 101, 121, 100, 0, 3,       118, 97, 108, 106, 106
```

If the formatting of that breakdown is messed up [here’s a raw gist](https://gist.github.com/wjessop/4747914/raw/a7cea5f08b87add27c677145fa49815ed0c98faf/gistfile1.txt) that may be clearer.

What you can see here are what the bytes represent (you can see the breakdown of each data type on the External Term Format [docs](http://erlang.org/doc/apps/erts/erl_ext_dist.html)). This is great, but why write a blog post just about dicts? Well, they’re easy to create in Ruby:

```ruby
BERT.encode(:complex => {"key" => [:data, {:structures => "are easy to serialise"}]})
=> "\x83h\x03d\x00\x04bertd\x00\x04dictl\x00\x00\x00\x01h\x02d\x00\acomplexh\x03d\x00\x04bertd\x00\x04dictl\x00\x00\x00\x01h\x02m\x00\x00\x00\x03keyl\x00\x00\x00\x02d\x00\x04datah\x03d\x00\x04bertd\x00\x04dictl\x00\x00\x00\x01h\x02d\x00\nstructuresm\x00\x00\x00\x15are easy to serialisejjjj"
```

but it’s not so obvious in Go, and I hit some issues when trying to create them.

## Serialising to BERT in Golang

Serialising data to BERT/BERP in Go is pretty easy for simple cases using the [gobert](https://github.com/sethwklein/gobert) lib:

```go
package main

import (
    "fmt"
    "bytes"
    "github.com/sethwklein/gobert"
)

func main() {
    var buf = new(bytes.Buffer)
    bert.MarshalResponse(buf, bert.Atom("foo"))
    for _, b := range(buf.Bytes()) {
        fmt.Printf("%d ", b)
    }
    fmt.Println()
}

```

This gives us:

    0 0 0 7 131 100 0 3 102 111 111


If we run that through the Ruby lib decoder we get:

```ruby
> BERT.decode([131, 100, 0, 3, 102, 111, 111].pack("C*"))
 => :foo
```

(The Ruby bert lib decodes atoms to symbols).

## Serialising to BERT dicts in Golang

However, there is a little more effort involved serialising more complex data structures, in particular dicts, as I found out.

You might have thought that you could just pass in a map:

```go
package main

import (
    "fmt"
    "bytes"
    "github.com/sethwklein/gobert"
)

func main() {
    message := map[string]string{"key1": "val1", "key2": "val2"}

    var buf = new(bytes.Buffer)
    bert.MarshalResponse(buf, message)
    for _, b := range(buf.Bytes()) {
        fmt.Printf("%d ", b)
    }
    fmt.Println()
}
```

We get the output:

    0 0 0 1 131

Well, that doesn’t work. What you end up with is a one byte long BERP. It seems that gobert doesn’t automatically serialise maps. No problem, we’ll build one up manually. A quick look at the BERT documentation shows the format of a dict:

> “Dictionaries (hash tables) are expressed via an array of 2-tuples representing the key/value pairs. The KeysAndValues array is mandatory, such that an empty dict is expressed as {bert, dict, \[\]}. Keys and values may be any term. For example, {bert, dict, \[{name, <<“Tom”>>}, {age, 30}\]}.”

So let's create this special structure manually.

```go
package main

import (
    "fmt"
    "bytes"
    "github.com/sethwklein/gobert"
)

func main() {
    message1 := []bert.Term{bert.Atom("key1"), bert.Atom("val1")}
    message2 := []bert.Term{bert.Atom("key2"), bert.Atom("val3")}
    keys_and_values := []bert.Term{message1, message2}

    dict := []bert.Term{bert.BertAtom, bert.Atom("dict"), keys_and_values}

    var buf = new(bytes.Buffer)
    bert.MarshalResponse(buf, dict)
    for _, b := range(buf.Bytes()) {
        fmt.Printf("%d ", b)
    }
    fmt.Println()
}
```

The result:

    0 0 0 51 131 104 3 100 0 4 98 101 114 116 100 0 4 100 105 99 116 104 2 104 2 100 0 4 107 101 121 49 100 0 4 118 97 108 49 104 2 100 0 4 107 101 121 50 100 0 4 118 97 108 51

It looks better, but it doesn’t decode, using Ruby:

```ruby
> BERT.decode([131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 104, 2, 104, 2, 100, 0, 4, 107, 101, 121, 49, 100, 0, 4, 118, 97, 108, 49, 104, 2, 100, 0, 4, 107, 101, 121, 50, 100, 0, 4, 118, 97, 108, 51].pack("C*"))
TypeError: Invalid dict spec, not an erlang list
```

We’re still missing something. Let's compare the output of the Ruby bert lib to the output of gobert for the same data structure:

```ruby
> BERT.encode({:key1 => :val1, :key2 => :val2}).unpack("C*")
 => [131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 2, 104, 2, 100, 0, 4, 107, 101, 121, 49, 100, 0, 4, 118, 97, 108, 49, 104, 2, 100, 0, 4, 107, 101, 121, 50, 100, 0, 4, 118, 97, 108, 50, 106]
```

We’re definitely missing some data in the gobert output.

If you follow along the byte sequences you can see that they start off the same until the 18th byte. In the Ruby output this is ‘108’, or LIST\_EXT. In the gobert output it’s 104, a SMALL\_TUPLE\_EXT. We can see where this difference happens in encode.go in the gobert lib (in the writeTag func):

```go
case reflect.Slice:
    writeSmallTuple(w, v)
case reflect.Array:
    writeList(w, v)
```

Let's decode the BERT data to see where the diversion happens in the underlying data structures:

```
magic| tuple  |  atom   |       bert       |   atom   |    dict
  131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116
```

We can see that the “bert” and “dict” atoms are encoded the same, but the keys\_and\_values array is getting encoded as a SMALL\_TUPLE\_EXT by gobert when we wanted a LIST\_EXT. If we look back at the gobert code we can see that the decision to use SMALL\_TUPLE\_EXT over LIST\_EXT is dependent on a slice or array being present. We can use the go “reflect” package to look at the arrays/slices we are creating and see what they are:

```go
package main

import (
    "fmt"
    "reflect"
    "github.com/sethwklein/gobert"
)

func main() {
    array := [2]bert.Term{}
    slice := []bert.Term{}

    array_val := reflect.ValueOf(array)
    slice_val := reflect.ValueOf(slice)
    fmt.Printf("array is a: %v\n", array_val.Kind())
    fmt.Printf("slice is a: %v\n", slice_val.Kind())
}
```

    array is a: array
    slice is a: slice

## The fix

So, in order to fix our data structure to get gobert to correctly encode the dict we need to change the keys\_and\_values slice to an array:

```go
package main

import (
    "fmt"
    "bytes"
    "github.com/sethwklein/gobert"
)

func main() {
    message1 := []bert.Term{bert.Atom("key1"), bert.Atom("val1")}
    message2 := []bert.Term{bert.Atom("key2"), bert.Atom("val3")}
    keys_and_values := [2]bert.Term{message1, message2} // Now an array

    dict := []bert.Term{bert.BertAtom, bert.Atom("dict"), keys_and_values}

    var buf = new(bytes.Buffer)
    bert.MarshalResponse(buf, dict)
    for _, b := range(buf.Bytes()) {
        fmt.Printf("%d ", b)
    }
    fmt.Println()
}
```

The result:

    0 0 0 55 131 104 3 100 0 4 98 101 114 116 100 0 4 100 105 99 116 108 0 0 0 2 104 2 100 0 4 107 101 121 49 100 0 4 118 97 108 49 104 2 100 0 4 107 101 121 50 100 0 4 118 97 108 51 106

But more importantly, can we decode the data we encoded?

```ruby
> BERT.decode([131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 2, 104, 2, 100, 0, 4, 107, 101, 121, 49, 100, 0, 4, 118, 97, 108, 49, 104, 2, 100, 0, 4, 107, 101, 121, 50, 100, 0, 4, 118, 97, 108, 51, 106].pack("C*"))
 => {:key1=>:val1, :key2=>:val3}
```

Yes!
