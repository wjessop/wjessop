---
title: Fixing errors installing the charlock_holmes ruby gem redux
date: 2025-05-29T10:50:00Z
draft: false
tags: ["Ruby", "MacOS", "tech", "programming"]
summary: The charlock_holmes gem can be hard to install, here's how I solved a common problem, updated for 2025
category: ""
description: How to fix the charlock_holmes gem install error about missing icu4c again.
type: Post
---

A while back I posted about [fixing an error installing the charlock_holmes gem on MacOS](/posts/fixing-errors-installing-the-charlock_holmes-ruby-gem/), well the error has returned. Here's the newest fix.

If you get an error that looks something like this:

```sh
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

current directory:
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
/Users/will/.rbenv/versions/3.4.3/bin/ruby extconf.rb
--with-opt-dir\=/usr/local/opt --with-opt-include\=/usr/local/opt/icu4c/include
--with-opt-lib\=/usr/local/opt/icu4c/lib --with-cxxflags\=-std\=c++11
checking for pkg-config for icu-i18n...
["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ",
"-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licui18n"]
checking for pkg-config for icu-io...
["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ",
"-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licuio"]
checking for pkg-config for icu-uc...
["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ",
"-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licuuc"]
checking for -licui18n... yes
checking for unicode/ucnv.h... yes
checking for -lz... yes
checking for -licuuc... yes
checking for -licudata... yes
checking for icu that requires explicit C++ version flag... yes
checking for icu that compiles with c++20 standard... yes
Static linking is disabled.
creating Makefile

current directory:
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
make DESTDIR\= sitearchdir\=./.gem.20250529-47905-r2zqyx
sitelibdir\=./.gem.20250529-47905-r2zqyx clean

current directory:
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
make DESTDIR\= sitearchdir\=./.gem.20250529-47905-r2zqyx
sitelibdir\=./.gem.20250529-47905-r2zqyx
compiling converter.c
In file included from converter.c:2:
In file included from ./common.h:9:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6:
warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37:
warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling encoding_detector.c
In file included from encoding_detector.c:2:
In file included from ./common.h:9:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6:
warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37:
warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling ext.c
In file included from ext.c:1:
In file included from ./common.h:9:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6:
warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37:
warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling transliterator.cpp
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:15:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/utypes.h:39:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/uversion.h:182:11: warning:
nested namespace definition is a C++17 extension; define each namespace
separately [-Wc++17-extensions]
  182 | namespace U_HEADER_ONLY_NAMESPACE {}
      |           ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/uversion.h:180:48: note:
expanded from macro 'U_HEADER_ONLY_NAMESPACE'
180 | #define U_HEADER_ONLY_NAMESPACE
U_ICU_NAMESPACE::U_HEADER_NESTED_NAMESPACE
      |                                                ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:271:38: error: no
template named 'enable_if_t' in namespace 'std'
271 | template<typename T, typename = std::enable_if_t<std::is_same_v<T,
UChar>>>
      |                                 ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:271:55: error: no
template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
271 | template<typename T, typename = std::enable_if_t<std::is_same_v<T,
UChar>>>
      |                                                  ~~~~~^~~~~~~~~
      |                                                       is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29:
note: 'is_same' declared here
22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)>
{};
      |                             ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:8: warning:
constexpr if is a C++17 extension [-Wc++17-extensions]
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |        ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:24: error: no
template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |                   ~~~~~^~~~~~~~~
      |                        is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29:
note: 'is_same' declared here
22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)>
{};
      |                             ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:50: error:
expected unqualified-id
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |                                                  ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:385:16: warning:
variable templates are a C++14 extension [-Wc++14-extensions]
  385 | constexpr bool ConvertibleToU16StringView =
      |                ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:386:10: error: no
template named 'is_convertible_v' in namespace 'std'; did you mean
'is_convertible'?
  386 |     std::is_convertible_v<T, std::u16string_view>
      |     ~~~~~^~~~~~~~~~~~~~~~
      |          is_convertible
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_convertible.h:22:29:
note: 'is_convertible' declared here
22 | struct _LIBCPP_TEMPLATE_VIS is_convertible : public
integral_constant<bool, __is_convertible(_T1, _T2)> {};
      |                             ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:393:5: error:
expected '(' for function-style cast or type construction
  386 |     std::is_convertible_v<T, std::u16string_view>
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
387 | #if !U_CHAR16_IS_TYPEDEF && (!defined(_LIBCPP_VERSION) ||
_LIBCPP_VERSION < 180000)
  388 |     || std::is_convertible_v<T, std::basic_string_view<uint16_t>>
  389 | #endif
  390 | #if U_SIZEOF_WCHAR_T==2
  391 |     || std::is_convertible_v<T, std::wstring_view>
  392 | #endif
  393 |     ;
      |     ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:36: error: no
type named 'enable_if_t' in namespace 'std'
429 |           typename = typename
std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
      |                      ~~~~~~~~~~~~~~^~~~~~~~~~~
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:47: error:
expected ',' or '>' in template-parameter-list
429 |           typename = typename
std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
      |                                               ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:93: error:
expected unqualified-id
429 |           typename = typename
std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
|
^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:36: error: no
type named 'enable_if_t' in namespace 'std'
439 |           typename = typename
std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
      |                      ~~~~~~~~~~~~~~^~~~~~~~~~~
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:47: error:
expected ',' or '>' in template-parameter-list
439 |           typename = typename
std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
      |                                               ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:92: error:
expected unqualified-id
439 |           typename = typename
std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
|
^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:40:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:134:29: error:
no template named 'enable_if_t' in namespace 'std'
  134 |             typename = std::enable_if_t<
      |                        ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:135:23: error:
no template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
  135 |                 (std::is_same_v<decltype(T().data()), const char*>
      |                  ~~~~~^~~~~~~~~
      |                       is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29:
note: 'is_same' declared here
22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)>
{};
      |                             ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:40:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:140:17: error:
use of address-of-label extension outside of a function body
  140 |                 std::is_same_v<decltype(T().size()), size_t>>>
      |                 ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:140:62: error:
expected member name or ';' after declaration specifiers
  140 |                 std::is_same_v<decltype(T().size()), size_t>>>
      |                                                              ^
In file included from transliterator.cpp:5:
In file included from
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:346:40: error: no
template named 'enable_if_t' in namespace 'std'
346 |   template<typename S, typename =
std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:381:40: error: no
template named 'enable_if_t' in namespace 'std'
381 |   template<typename S, typename =
std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:1959:40: error: no
template named 'enable_if_t' in namespace 'std'
1959 |   template<typename S, typename =
std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
fatal error: too many errors emitted, stopping now [-ferror-limit=]
3 warnings and 20 errors generated.
make: *** [transliterator.o] Error 1

make failed, exit code 2

Gem files will remain installed in
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9
for inspection.
Results logged to
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/extensions/arm64-darwin-24/3.4.0/charlock_holmes-0.7.9/gem_make.out

/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:126:in
'Gem::Ext::Builder.run'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:52:in
'block in Gem::Ext::Builder.make'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:44:in
'Array#each'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:44:in
'Gem::Ext::Builder.make'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/ext_conf_builder.rb:44:in
'Gem::Ext::ExtConfBuilder.build'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:195:in
'Gem::Ext::Builder#build_extension'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:229:in
'block in Gem::Ext::Builder#build_extensions'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:226:in
'Array#each'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:226:in
'Gem::Ext::Builder#build_extensions'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/installer.rb:844:in
'Gem::Installer#build_extensions'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/rubygems_gem_installer.rb:76:in
'Bundler::RubyGemsGemInstaller#build_extensions'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/rubygems_gem_installer.rb:28:in
'Bundler::RubyGemsGemInstaller#install'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/source/rubygems.rb:203:in
'Bundler::Source::Rubygems#install'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/gem_installer.rb:54:in
'Bundler::GemInstaller#install'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/gem_installer.rb:16:in
'Bundler::GemInstaller#install_from_spec'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/parallel_installer.rb:130:in
'Bundler::ParallelInstaller#do_install'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/parallel_installer.rb:121:in
'block in Bundler::ParallelInstaller#worker_pool'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:62:in
'Bundler::Worker#apply_func'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:57:in
'block in Bundler::Worker#process_queue'
  <internal:kernel>:168:in 'Kernel#loop'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:54:in
'Bundler::Worker#process_queue'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:90:in
'block (2 levels) in Bundler::Worker#create_threads'

An error occurred while installing charlock_holmes (0.7.9), and Bundler
cannot continue.

In Gemfile:
  charlock_holmes
will@lentil ~/clients/Outvote/repos/web-app/master (on master)% gem uninstall charlock_holmes
Gem 'charlock_holmes' is not installed
will@lentil ~/clients/Outvote/repos/web-app/master (on master)% git pull
will@lentil ~/clients/Outvote/repos/web-app/master (on master)% bundle
Fetching gem metadata from https://enterprise.contribsys.com/..
Fetching gem metadata from https://rubygems.org/........
Installing charlock_holmes 0.7.9 with native extensions
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    current directory: /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
/Users/will/.rbenv/versions/3.4.3/bin/ruby extconf.rb --with-opt-dir\=/usr/local/opt --with-opt-include\=/usr/local/opt/icu4c/include
--with-opt-lib\=/usr/local/opt/icu4c/lib --with-cxxflags\=-std\=c++11
checking for pkg-config for icu-i18n... ["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ", "-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licui18n"]
checking for pkg-config for icu-io... ["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ", "-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licuio"]
checking for pkg-config for icu-uc... ["-I/opt/homebrew/Cellar/icu4c@77/77.1/include ", "-L/opt/homebrew/Cellar/icu4c@77/77.1/lib", "-licuuc"]
checking for -licui18n... yes
checking for unicode/ucnv.h... yes
checking for -lz... yes
checking for -licuuc... yes
checking for -licudata... yes
checking for icu that requires explicit C++ version flag... yes
checking for icu that compiles with c++20 standard... yes
Static linking is disabled.
creating Makefile

current directory: /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
make DESTDIR\= sitearchdir\=./.gem.20250529-48158-xjue2n sitelibdir\=./.gem.20250529-48158-xjue2n clean

current directory: /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9/ext/charlock_holmes
make DESTDIR\= sitearchdir\=./.gem.20250529-48158-xjue2n sitelibdir\=./.gem.20250529-48158-xjue2n
compiling converter.c
In file included from converter.c:2:
In file included from ./common.h:9:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6: warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37: warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling encoding_detector.c
In file included from encoding_detector.c:2:
In file included from ./common.h:9:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6: warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37: warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling ext.c
In file included from ext.c:1:
In file included from ./common.h:9:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby.h:38:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/ruby.h:27:
In file included from /Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/internal/anyargs.h:83:
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:6: warning: 'RUBY_API_VERSION_MAJOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |      ^
/Users/will/.rbenv/versions/3.4.3/include/ruby-3.4.0/ruby/backward/cxxanyargs.hpp:540:37: warning: 'RUBY_API_VERSION_MINOR' is not defined, evaluates to 0 [-Wundef]
  540 | #if (RUBY_API_VERSION_MAJOR * 100 + RUBY_API_VERSION_MINOR) >= 301
      |                                     ^
2 warnings generated.
compiling transliterator.cpp
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:15:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/utypes.h:39:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/uversion.h:182:11: warning: nested namespace definition is a C++17 extension; define each namespace separately
[-Wc++17-extensions]
  182 | namespace U_HEADER_ONLY_NAMESPACE {}
      |           ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/uversion.h:180:48: note: expanded from macro 'U_HEADER_ONLY_NAMESPACE'
  180 | #define U_HEADER_ONLY_NAMESPACE U_ICU_NAMESPACE::U_HEADER_NESTED_NAMESPACE
      |                                                ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:271:38: error: no template named 'enable_if_t' in namespace 'std'
  271 | template<typename T, typename = std::enable_if_t<std::is_same_v<T, UChar>>>
      |                                 ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:271:55: error: no template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
  271 | template<typename T, typename = std::enable_if_t<std::is_same_v<T, UChar>>>
      |                                                  ~~~~~^~~~~~~~~
      |                                                       is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29: note: 'is_same' declared here
   22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)> {};
      |                             ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:8: warning: constexpr if is a C++17 extension [-Wc++17-extensions]
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |        ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:24: error: no template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |                   ~~~~~^~~~~~~~~
      |                        is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29: note: 'is_same' declared here
   22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)> {};
      |                             ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:273:50: error: expected unqualified-id
  273 |     if constexpr (std::is_same_v<UChar, char16_t>) {
      |                                                  ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:385:16: warning: variable templates are a C++14 extension [-Wc++14-extensions]
  385 | constexpr bool ConvertibleToU16StringView =
      |                ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:386:10: error: no template named 'is_convertible_v' in namespace 'std'; did you mean 'is_convertible'?
  386 |     std::is_convertible_v<T, std::u16string_view>
      |     ~~~~~^~~~~~~~~~~~~~~~
      |          is_convertible
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_convertible.h:22:29: note: 'is_convertible' declared here
   22 | struct _LIBCPP_TEMPLATE_VIS is_convertible : public integral_constant<bool, __is_convertible(_T1, _T2)> {};
      |                             ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:37:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:393:5: error: expected '(' for function-style cast or type construction
  386 |     std::is_convertible_v<T, std::u16string_view>
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  387 | #if !U_CHAR16_IS_TYPEDEF && (!defined(_LIBCPP_VERSION) || _LIBCPP_VERSION < 180000)
  388 |     || std::is_convertible_v<T, std::basic_string_view<uint16_t>>
  389 | #endif
  390 | #if U_SIZEOF_WCHAR_T==2
  391 |     || std::is_convertible_v<T, std::wstring_view>
  392 | #endif
  393 |     ;
      |     ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:36: error: no type named 'enable_if_t' in namespace 'std'
  429 |           typename = typename std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
      |                      ~~~~~~~~~~~~~~^~~~~~~~~~~
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:47: error: expected ',' or '>' in template-parameter-list
  429 |           typename = typename std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
      |                                               ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:429:93: error: expected unqualified-id
  429 |           typename = typename std::enable_if_t<!std::is_pointer_v<std::remove_reference_t<T>>>>
      |                                                                                             ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:36: error: no type named 'enable_if_t' in namespace 'std'
  439 |           typename = typename std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
      |                      ~~~~~~~~~~~~~~^~~~~~~~~~~
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:47: error: expected ',' or '>' in template-parameter-list
  439 |           typename = typename std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
      |                                               ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/char16ptr.h:439:92: error: expected unqualified-id
  439 |           typename = typename std::enable_if_t<std::is_pointer_v<std::remove_reference_t<T>>>,
      |                                                                                            ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:40:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:134:29: error: no template named 'enable_if_t' in namespace 'std'
  134 |             typename = std::enable_if_t<
      |                        ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:135:23: error: no template named 'is_same_v' in namespace 'std'; did you mean 'is_same'?
  135 |                 (std::is_same_v<decltype(T().data()), const char*>
      |                  ~~~~~^~~~~~~~~
      |                       is_same
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/__type_traits/is_same.h:22:29: note: 'is_same' declared here
   22 | struct _LIBCPP_TEMPLATE_VIS is_same : _BoolConstant<__is_same(_Tp, _Up)> {};
      |                             ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:40:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:140:17: error: use of address-of-label extension outside of a function body
  140 |                 std::is_same_v<decltype(T().size()), size_t>>>
      |                 ^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/stringpiece.h:140:62: error: expected member name or ';' after declaration specifiers
  140 |                 std::is_same_v<decltype(T().size()), size_t>>>
      |                                                              ^
In file included from transliterator.cpp:5:
In file included from /opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/translit.h:27:
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:346:40: error: no template named 'enable_if_t' in namespace 'std'
  346 |   template<typename S, typename = std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:381:40: error: no template named 'enable_if_t' in namespace 'std'
  381 |   template<typename S, typename = std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
/opt/homebrew/Cellar/icu4c@77/77.1/include/unicode/unistr.h:1959:40: error: no template named 'enable_if_t' in namespace 'std'
 1959 |   template<typename S, typename = std::enable_if_t<ConvertibleToU16StringView<S>>>
      |                                   ~~~~~^
fatal error: too many errors emitted, stopping now [-ferror-limit=]
3 warnings and 20 errors generated.
make: *** [transliterator.o] Error 1

make failed, exit code 2

Gem files will remain installed in /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/charlock_holmes-0.7.9 for inspection.
Results logged to /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/extensions/arm64-darwin-24/3.4.0/charlock_holmes-0.7.9/gem_make.out

  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:126:in 'Gem::Ext::Builder.run'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:52:in 'block in Gem::Ext::Builder.make'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:44:in 'Array#each'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:44:in 'Gem::Ext::Builder.make'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/ext_conf_builder.rb:44:in 'Gem::Ext::ExtConfBuilder.build'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:195:in 'Gem::Ext::Builder#build_extension'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:229:in 'block in Gem::Ext::Builder#build_extensions'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:226:in 'Array#each'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/ext/builder.rb:226:in 'Gem::Ext::Builder#build_extensions'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/3.4.0/rubygems/installer.rb:844:in 'Gem::Installer#build_extensions'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/rubygems_gem_installer.rb:76:in 'Bundler::RubyGemsGemInstaller#build_extensions'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/rubygems_gem_installer.rb:28:in 'Bundler::RubyGemsGemInstaller#install'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/source/rubygems.rb:203:in 'Bundler::Source::Rubygems#install'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/gem_installer.rb:54:in 'Bundler::GemInstaller#install'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/gem_installer.rb:16:in 'Bundler::GemInstaller#install_from_spec'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/parallel_installer.rb:130:in 'Bundler::ParallelInstaller#do_install'
/Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/installer/parallel_installer.rb:121:in 'block in
Bundler::ParallelInstaller#worker_pool'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:62:in 'Bundler::Worker#apply_func'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:57:in 'block in Bundler::Worker#process_queue'
  <internal:kernel>:168:in 'Kernel#loop'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:54:in 'Bundler::Worker#process_queue'
  /Users/will/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0/gems/bundler-2.4.22/lib/bundler/worker.rb:90:in 'block (2 levels) in Bundler::Worker#create_threads'

An error occurred while installing charlock_holmes (0.7.9), and Bundler cannot continue.

In Gemfile:
  charlock_holmes
```

Try installing using a newer c++ standard:

```sh
gem install charlock_holmes -v=0.7.9 -- --with-opt-dir=/usr/local/opt --with-opt-include=/usr/local/opt/icu4c/include --with-opt-lib=/usr/local/opt/icu4c/lib --with-cxxflags=-std=c++17
Building native extensions with: '--with-opt-dir=/usr/local/opt --with-opt-include=/usr/local/opt/icu4c/include --with-opt-lib=/usr/local/opt/icu4c/lib --with-cxxflags=-std=c++17'
This could take a while...
Successfully installed charlock_holmes-0.7.9
1 gem installed
```
