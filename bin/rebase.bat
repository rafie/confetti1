@echo off

setlocal
set here=%~dp0
pushd %here%\..\..

pushd classico1-bento
call git fetch origin master
call git merge origin/master
popd

pushd classico1-ruby
call git fetch origin master
call git merge origin/master
popd

pushd confetti1
call git fetch origin master
call git merge origin/master
popd