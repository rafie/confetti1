#!/usr/bin/env ruby

require 'rubygems'
require 'win32/Console/ANSI' if RUBY_PLATFORM =~ /mingw/
require 'commander/import'

# HighLine::use_color = false

program :name, 'tt - Confetti'
program :version, '1.0.0'
program :description, 'A configuration management system.'
default_command :help

require 'Bento'
require 'Confetti'

require_relative 'Commands/mkact'
# require_relative 'Commands/mkview'
require_relative 'Commands/lsact'
require_relative 'Commands/check'
require_relative 'Commands/merge'
require_relative 'Commands/build'
require_relative 'Commands/mkver'
require_relative 'Commands/nomerge'
require_relative 'Commands/release'

command :mkact   do |c| Confetti::Commands::MkAct.command(c) ; end
command :lsact   do |c| Confetti::Commands::LsAct.command(c) ; end
command :check   do |c| Confetti::Commands::Check.command(c) ; end
command :merge   do |c| Confetti::Commands::Merge.command(c) ; end
command :build   do |c| Confetti::Commands::Build.command(c) ; end
command :release do |c| Confetti::Commands::Release.command(c) ; end
command :mkver   do |c| Confetti::Commands::MkVer.command(c) ; end
# command :nomerge do |c| Confetti::Commands::NoMerge.command(c) ; end
# command :mkview do |c| Confetti::Commands::Mkview.command(c) ; end
# command :changes do |c| Confetti::Commands::Changes.command(c) ; end
# command :lsch do |c| Confetti::Commands::LsCh.command(c) ; end
