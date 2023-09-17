---
title: "Fixing the ruby 'CoreFoundation/CFString.h' file not found install error"
date: 2019-05-01T15:00:33Z
draft: false
tags: ["ruby", "programming", "MacOS"]
summary: "You just need to install the headers"
category: ""
type: Post
---
I hit this error installing the latest Ruby using rbenv:

```sh
$ rbenv install 2.6.3
ruby-build: use openssl from homebrew
Downloading ruby-2.6.3.tar.bz2...
-> https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.3.tar.bz2
Installing ruby-2.6.3...
ruby-build: use readline from homebrew
BUILD FAILED (OS X 10.14.4 using ruby-build 20190423)
Inspect or clean up the working tree at /var/folders/r7/kjzbwmx533b20hcf1_s9kc9c0000gn/T/ruby-build.20190501131413.33977
Results logged to /var/folders/r7/kjzbwmx533b20hcf1_s9kc9c0000gn/T/ruby-build.20190501131413.33977.log
Last 10 log lines:
compiling error.c
compiling eval.c
compiling file.c
compiling gc.c
file.c:23:10: fatal error: 'CoreFoundation/CFString.h' file not found
#include
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
make: *** [file.o] Error 1
make: *** Waiting for unfinished jobs....
```

The problem is missing headers. To re-install just run this command:

```sh
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

Now, Ruby should install just fine:

```sh
$ rbenv install 2.6.3
ruby-build: use openssl from homebrew
Downloading ruby-2.6.3.tar.bz2...
-\> https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.3.tar.bz2
Installing ruby-2.6.3...
ruby-build: use readline from homebrew
Installed ruby-2.6.3 to /Users/will/.rbenv/versions/2.6.3 ``
```
