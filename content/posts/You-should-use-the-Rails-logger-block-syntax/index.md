---
title: You should use the Ruby on Rails logger block syntax
date: 2024-07-31T17:00:00+01:00
draft: false
preview: false
tags: [programming, ruby, rails, ruby on rails, performance, tech]
summary: A description of how to save memory and CPU time using the Ruby on Rails logger block syntax with examples of the memory saved
description: Using Ruby on Rails logger block syntax can save you object allocations in the Ruby VM, and CPU time, I show you how to use it and the difference using it can make
category: ""
type: Post
---

## Summary

Passing strings to the Rails logger methods (eg. `Rails.logger.info(…)`) causes unecessary object allocations, and if you're calling methods to generate data for your log messages then it can cause unecessary CPU work too. In this post I'll show you how to use block syntax when using your logger with Rails to save object allocations and CPU time.

## The Context

When you're logging in Ruby on Rails log messages sent with a level above the currently configured log level will not be logged. The default in production is to log at `info` or below, so anything logged at debug level will not be output to the logs:

```
debug  ⬆️ Ignored
-----------------
info   ⬇️  Logged
warn
error
fatal
unknown
```

The log level can be set in the environment configs, from `config/environments/production.rb`:

```ruby
config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
```

The log level can also be changed at any time, including in the Rails console, by setting the log level directly:

```ruby
> Rails.logger.level = :warn
=> :warn
```

## The problem - Object allocations for unused logs

<aside>
For these examples going to be using the excellent <a href="https://github.com/srawlins/allocation_stats">allocation_stats ruby gem</a> to get object allocation counts.
</aside>

Let's say you want to log some debug data for an API call that a user is making. You might do something like this:

```ruby
Rails.logger.debug "Processed API request to host #{somehost} for user \
  #{user.name} (#{user.id}): status: #{request_status} user_details: #{user.to_json}"
```

You push this code to production, it's useful to have a way to debug user API issues just by setting the Rails log level to `debug` from `info` using the `RAILS_LOG_LEVEL` environment variable, you can always set it back to `info` when you're done. Let's look at what this statement allocates when the application is logging at the `debug` level:

```ruby
# Set the log level
> Rails.logger.level = :debug
=> :debug

# Do the logging
> stats = AllocationStats.trace {
	Rails.logger.debug "Processed API request to \
      host #{somehost} for user #{user.name} (#{user.id}): status: #{request_status} \
      user_details: #{user.to_json}"
}
Processed API request to host for user Slartibartfast (42): status: DENIED user_details: {"id":42,"name":"Slartibartfast","email":"s.bartfast@magrathea.biz","favourite_colour":"blue"}
=> [#<AllocationStats::Allocation:0x000000015489fe18 @object=#<Proc:0x000000015471e9e0 activesupport-7.1.3.4/lib/active_support/broadcas...

# Get an allocation count, source paths shortened for brevity
> puts stats.allocations.group_by(:sourcefile, :sourceline, :class).to_text
                           sourcefile                             sourceline                      class                      count
----------------------------------------------------------------- ----------  ---------------------------------------------  -----
activesupport-7.1.3.4/lib/active_support/broadcast_logger.rb             231  Proc                                               1
(irb)                                                                     45  Array                                              1
ruby/3.3.0/json/common.rb                                                303  JSON::Ext::Generator::State                        1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb         188  String                                             4
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                 23  ActiveSupport::JSON::Encoding::JSONGemEncoder      1
(irb)                                                                     13  String                                             1
(irb)                                                                     45  String                                             2
<internal:timev>                                                         226  Time                                               2
ruby/3.3.0/json/common.rb                                                305  String                                             1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                 92  Hash                                               1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                 77  Hash                                               1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb         186  Hash                                               1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb          78  Hash                                               1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                 33  Hash                                               1
ruby/3.3.0/logger/log_device.rb                                           42  String                                             1
activesupport-7.1.3.4/lib/active_support/logger.rb                        38  String                                             2
ruby/3.3.0/logger/log_device.rb                                          128  File::Stat                                         1
```

This is fine! We're logging some data, the Ruby VM is doing work and allocates objects. Let's look at what happens when we change the log level to `info` when we're done debugging:

```ruby
# Set the log level
> Rails.logger.level = :info
=> :info

# Do the logging
> stats = AllocationStats.trace {
	Rails.logger.debug "Processed API request to \
      host #{somehost} for user #{user.name} (#{user.id}): status: #{request_status} \
      user_details: #{user.to_json}"
}
=> [#<AllocationStats::Allocation:0x000000015489fd28 @object=#<Proc:0x000000015471e648 activesupport-7.1.3.4/lib/active_support/broadcas...

# Get an allocation count, source paths shortened for brevity
> puts stats.allocations.group_by(:sourcefile, :sourceline, :class).to_text
                           sourcefile                              sourceline                      class                      count
-----------------------------------------------------------------  ----------  ---------------------------------------------  -----
activesupport-7.1.3.4/lib/active_support/broadcast_logger.rb              231  Proc                                               1
(irb)                                                                      48  Array                                              1
/Users/will/.rbenv/versions/3.3.0/lib/ruby/3.3.0/json/common.rb           303  JSON::Ext::Generator::State                        1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb          188  String                                             4
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                  23  ActiveSupport::JSON::Encoding::JSONGemEncoder      1
(irb)                                                                      13  String                                             1
(irb)                                                                      48  String                                             2
/Users/will/.rbenv/versions/3.3.0/lib/ruby/3.3.0/json/common.rb           305  String                                             1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                  92  Hash                                               1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                  77  Hash                                               1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb          186  Hash                                               1
activesupport-7.1.3.4/lib/active_support/core_ext/object/json.rb           78  Hash                                               1
activesupport-7.1.3.4/lib/active_support/json/encoding.rb                  33  Hash                                               1
```

This code didn't log anything beacuse the log level is set to `info` and we called the `debug` log level method, however __we still allocated almost as many objects!__.

## Why this happens

When we call `Rails.logger.debug` with a string, say `"Hello #{name}, here's some #{generated_data}!"`, the string is created as an object, including any interpolation that is required which may include methods that are called to retrieve or generate the data which also allocates objects. This happens before the string is passed to the method _regardless of the current log level_, it is up to the logger when passed this now created string to decide if it is going to log it or not. That's wasteful!

## The solution, passing a block to the logger

Let's run that debug code again but this time pass a block to the logger:

```ruby
# Set the log level
> Rails.logger.level = :info
=> :info

# Do the logging
> stats = AllocationStats.trace {
	Rails.logger.debug { "Processed API request to \
      host #{somehost} for user #{user.name} (#{user.id}): status: #{request_status} \
      user_details: #{user.to_json}" }
}
=> [#<AllocationStats::Allocation:0x000000015489ffa8 @object=#<Proc:0x000000015471ea58 /Users/will/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/activesupport-7.1.3.4/lib/active_support/broadcas...

# Get an allocation count, source paths shortened for brevity
> puts stats.allocations.group_by(:sourcefile, :sourceline, :class).to_text
                          sourcefile                          sourceline  class  count
------------------------------------------------------------  ----------  -----  -----
activesupport-7.1.3.4/lib/active_support/broadcast_logger.rb         231  Proc       2
(irb)                                                                 51  Array      1
```

That's a lot better, we're still not logging anything but the allocations are now significantly reduced. Ideally we'd allocate zero objects when logging nothing, but allocating three is a lot better than what we were allocationg before.

This works because when you pass a block to the logger method (`debug` in this case) the block will only be called if the log level is currently being logged. We had set the log level to `info` which meant that the block passed to the `debug` method was never called, and the object allocations to generate the string never happened.

## Why should I care?

The examples given here are admittedly trivial (and a little contrived to show the difference), and for an application that doesn't log much or doesn't get much traffic then the benefit is going to be tiny, but the effort involved in making the change to block syntax is _really_ small, it's not detrimental to the code readability either. Small applications can eventually grow into large ones, a handful of requests per second can change to thousands, and if that happens the block syntax can make a difference and you'll likely be glad you made it a habit.
