@echo off

setlocal
pushd classico1
call git fetch origin master
call git merge origin/master
popd

pushd confetti1
call git fetch origin master
call git merge origin/master
popd

pushd nexp
call git fetch origin master
call git merge origin/master
popd
