@echo off

setlocal
set here=%~dp0
pushd %here%\..\..

set comment=%1
if "%commend%"=="" set comment=...

pushd classico1-bento
call git commit -a -m"%comment%"
call git push origin master
popd

pushd classico1-ruby
call git commit -a -m"%comment%"
call git push origin master
popd

pushd confetti1
call git commit -a -m"%comment%"
call git push origin master
popd