@echo off

setlocal
set here=%~dp0
pushd %here%\..\..

call git clone http://github.com/rafie/classico1-bento
pushd classico1-bento
git remote set-url origin git@github.com:/rafie/classico1-bento.git
popd

call git clone http://github.com/rafie/classico1-ruby
pushd classico1-ruby
git remote set-url origin git@github.com:/rafie/classico1-ruby.git
popd

call git clone http://github.com/rafie/confetti1
pushd confetti1
git remote set-url origin git@github.com:/rafie/confetti1.git
popd

call git clone http://github.com/rafie/confetti1-import
pushd confetti1-import
git remote set-url origin git@github.com:/rafie/confetti1-import.git
popd
