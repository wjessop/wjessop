---
title: Fixing errors installing the charlock_holmes ruby gem
date: 2019-02-13T05:50:52Z
draft: false
tags: ["Ruby", "MacOS", "tech", "programming"]
summary: The charlock_holmes gem can be hard to install, here's how I solved a common problem
category: ""
description: Sometimes installing the charlock_holmes gem results in an error about missing icu4c, here's how to fix it.
type: Post
---

The charlock_holmes gem can be a PITA to install on a mac, this is what worked for me. If you get this error:

```sh
gem install charlock_holmes -v '0.7.7'
Building native extensions. This could take a while...
ERROR:  Error installing charlock_holmes:
ERROR: Failed to build gem native extension.

current directory: /Users/will/.rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/charlock_holmes-0.7.7/ext/charlock_holmes
/Users/will/.rbenv/versions/2.6.1/bin/ruby -I /Users/will/.rbenv/versions/2.6.1/lib/ruby/2.6.0 -r ./siteconf20190213-34122-e636v8.rb extconf.rb
checking for -licui18n... yes
checking for -licui18n... yes
checking for unicode/ucnv.h... no

***************************************************************************************
*********** icu required (brew install icu4c or apt-get install libicu-dev) ***********
***************************************************************************************
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers. Check the mkmf.log file for more details. You may
need configuration options.

Provided configuration options:
--with-opt-dir
--without-opt-dir
--with-opt-include
--without-opt-include=${opt-dir}/include
--with-opt-lib
--without-opt-lib=${opt-dir}/lib
--with-make-prog
--without-make-prog
--srcdir=.
--curdir
--ruby=/Users/will/.rbenv/versions/2.6.1/bin/$(RUBY_BASE_NAME)
--with-icu-dir
--without-icu-dir
--with-icu-include
--without-icu-include=${icu-dir}/include
--with-icu-lib
--without-icu-lib=${icu-dir}/lib
--with-icui18nlib
--without-icui18nlib
--with-icui18nlib
--without-icui18nlib

To see why this extension failed to compile, please check the mkmf.log which can be found here:

/Users/will/.rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/extensions/x86_64-darwin-18/2.6.0-static/charlock_holmes-0.7.7/mkmf.log

extconf failed, exit code 1

Gem files will remain installed in /Users/will/.rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/charlock_holmes-0.7.7 for inspection.
Results logged to /Users/will/.rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/extensions/x86_64-darwin-18/2.6.0-static/charlock_holmes-0.7.7/gem_make.out
```

First, make sure you have installed the required dependencies:

	brew install xz icu4c

Now, install charlock\_holmes:

	gem install charlock_holmes -v=0.7.7 -- --with-opt-dir=/usr/local/opt --with-opt-include=/usr/local/opt/icu4c/include --with-opt-lib=/usr/local/opt/icu4c/lib --with-cxxflags=-std=c++11
