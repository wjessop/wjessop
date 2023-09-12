---
title: Error installing libv8 on Mac OS Catalina
date: 2020-02-17T16:23:53Z
draft: true
tags: []
summary:
category: ""
type: Post
---
I got an error installing the libv8 gem on Catalina:

```sh
$ gem install libv8 -v '3.16.14.19'
Building native extensions.  This could take a while...
ERROR:  Error installing libv8:
	ERROR: Failed to build gem native extension.
    current directory: /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/ext/libv8
/Users/will/.rbenv/versions/2.4.5/bin/ruby -r ./siteconf20200217-34155-18bho1v.rb extconf.rb
creating Makefile
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/disable-building-tests.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/disable-werror-on-osx.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/disable-xcode-debugging.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/do-not-imply-vfp3-and-armv7.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/do-not-use-MAP_NORESERVE-on-freebsd.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/do-not-use-vfp2.patch
Applying /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/patches/fPIC-for-static.patch
Compiling v8 for x64
Using python 2.7.16
Using compiler: c++ (clang version 11.0.0)
Unable to find a compiler officially supported by v8.
It is recommended to use GCC v4.4 or higher
Beginning compilation. This will take some time.
Building v8 with env CXX=c++ LINK=c++  /usr/bin/make x64.release ARFLAGS.target=crs werror=no
GYP_GENERATORS=make \
	build/gyp/gyp --generator-output="out" build/all.gyp \
	              -Ibuild/standalone.gypi --depth=. \
	              -Dv8_target_arch=x64 \
	              -S.x64  -Dv8_enable_backtrace=1 -Dv8_can_use_vfp2_instructions=true -Darm_fpu=vfpv2 -Dv8_can_use_vfp3_instructions=true -Darm_fpu=vfpv3 -Dwerror=''
  CXX(target) /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/vendor/v8/out/x64.release/obj.target/preparser_lib/src/allocation.o
warning: include path for stdlibc++ headers not found; pass '-stdlib=libc++' on the command line to use the libc++ standard library instead [-Wstdlibcxx-not-found]
In file included from ../src/allocation.cc:33:
../src/utils.h:33:10: fatal error: 'climits' file not found
#include
         ^~~~~~~~~
1 warning and 1 error generated.
make[1]: *** [/Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/vendor/v8/out/x64.release/obj.target/preparser_lib/src/allocation.o] Error 1
make: *** [x64.release] Error 2
/Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/ext/libv8/location.rb:36:in `block in verify_installation!': libv8 did not install properly, expected binary v8 archive '/Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/vendor/v8/out/x64.release/obj.target/tools/gyp/libv8_base.a'to exist, but it was not found (Libv8::Location::Vendor::ArchiveNotFound)
	from /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/ext/libv8/location.rb:35:in `each'
	from /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/ext/libv8/location.rb:35:in `verify_installation!'
	from /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19/ext/libv8/location.rb:26:in `install!'
	from extconf.rb:7:in `'
extconf failed, exit code 1
Gem files will remain installed in /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/gems/libv8-3.16.14.19 for inspection.
Results logged to /Users/will/.rbenv/versions/2.4.5/lib/ruby/gems/2.4.0/extensions/x86_64-darwin-19/2.4.0/libv8-3.16.14.19/gem_make.out
```

## The Solution

The solution was as follows:

```sh
$ brew install v8@3.15
$ gem install libv8 -v '3.16.14.19' -- --with-system-v8
Building native extensions with: '--with-system-v8'
This could take a while...
Successfully installed libv8-3.16.14.19
1 gem installed
```
