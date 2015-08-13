@echo off

setlocal

set RUBY_ROOT=%CONFETTI_DATA%\classico1-ruby
set BENTO_ROOT=%CONFETTI_DATA%\classico1-bento
set CONFETTI_ROOT=%CONFETTI_DATA%\confetti1

set GEM_HOME=c:\rvdev\ruby\localgems
set GEM_PATH=%RUBY_ROOT%\Gems;%GEM_HOME%
set RUBYLIB=%BENTO_ROOT%\Classico;%CONFETTI_ROOT%;%RUBYLIB%
set PATH=%RUBY_ROOT%\Gems\bin;%RUBY_ROOT%\Ruby\bin;%CONFETTI_ROOT%\Confetti\bin;%PATH%

ruby %~dp0\tt.rb %*
