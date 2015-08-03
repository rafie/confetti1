@echo off

setlocal
set here=%~dp0
pushd %here%\..\..

pushd classico1-bento
call git clone http://github.com/rafie/classico1-bento
cd classico1-bento
git remote set-url origin git@github.com:/rafie/classico1-bento.git
popd

pushd classico1-ruby
call git clone http://github.com/rafie/classico1-ruby
cd classico1-ruby
git remote set-url origin git@github.com:/rafie/classico1-ruby.git
popd

pushd confetti1
call git clone http://github.com/rafie/confetti1
cd confetti1
git remote set-url origin git@github.com:/rafie/confetti1.git
popd

pushd confetti1-import
call git clone http://github.com/rafie/confetti1-import
cd confetti1-import
git remote set-url origin git@github.com:/rafie/confetti1-import.git
popd
