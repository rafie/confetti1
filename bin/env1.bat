@echo off

pushd %~dp0\..\..
set ROOT=%cd%

set HOME=%USERPROFILE%

: set RUBY_ROOT=%ROOT%\classico1-ruby
set RUBY_ROOT=d:\tmp\classico1-ruby
set BENTO_ROOT=%ROOT%\classico1-bento
set _CONFETTI_ROOT=%ROOT%\confetti1

set GEM_HOME=%ROOT%\localgems
set GEM_PATH=%RUBY_ROOT%\Gems;%GEM_HOME%
set PATH=%RUBY_ROOT%\Gems\bin;%RUBY_ROOT%\Ruby\bin;%_CONFETTI_ROOT%\Confetti\bin;%PATH%
set RUBYLIB=%BENTO_ROOT%\Classico;%_CONFETTI_ROOT%;%RUBYLIB%

popd
