@echo off

if "%CONFETTI_BASE%" == "" set CONFETTI_BASE=%~dp0\..\..\..

set RUBY_ROOT=%CONFETTI_BASE%\classico1-ruby
if exist d:\tmp\classico1-ruby set RUBY_ROOT=d:\tmp\classico1-ruby
set BENTO_ROOT=%CONFETTI_BASE%\classico1-bento
set CONFETTI_ROOT=%CONFETTI_BASE%\confetti1

set GEM_HOME=c:\rvdev\ruby\localgems
set GEM_PATH=%RUBY_ROOT%\Gems;%GEM_HOME%
set RUBYLIB=%BENTO_ROOT%\Classico;%CONFETTI_ROOT%;%RUBYLIB%
set PATH=%RUBY_ROOT%\Gems\bin;%RUBY_ROOT%\Ruby\bin;%CONFETTI_ROOT%\Confetti\bin;%PATH%
