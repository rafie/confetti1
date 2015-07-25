#!/usr/bin/env ruby

require 'mercenary'

# require 'Bento'
# require 'Confetti'

require_relative 'Commands/box'
require_relative 'Commands/mkact'
## require_relative 'Commands/mkview'
#require_relative 'Commands/lsact'
#require_relative 'Commands/check'
#require_relative 'Commands/merge'
#require_relative 'Commands/build'
#require_relative 'Commands/mkver'
#require_relative 'Commands/nomerge'
#require_relative 'Commands/release'

Mercenary.program(:tt) do |p|
	# p.version '1.0.0'
	p.description 'Confetti: A configuration management system'
	p.syntax 'tt [options] [arguments]'

	p.command(:box)     do |c| Confetti::Commands::Box.commands(c) ; end
	p.command(:mkact)   do |c| Confetti::Commands::mkact(c) ; end
#	p.command(:lsact)   do |c| Confetti::Commands::LsAct.command(c) ; end
#	p.command(:check)   do |c| Confetti::Commands::Check.command(c) ; end
#	p.command(:merge)   do |c| Confetti::Commands::Merge.command(c) ; end
#	p.command(:build)   do |c| Confetti::Commands::Build.command(c) ; end
#	p.command(:release) do |c| Confetti::Commands::Release.command(c) ; end
#	p.command(:mkver)   do |c| Confetti::Commands::MkVer.command(c) ; end
	# p.command(:nomerge) do |c| Confetti::Commands::NoMerge.command(c) ; end
	# p.command(:mkview)  do |c| Confetti::Commands::Mkview.command(c) ; end
	# p.command(:changes) do |c| Confetti::Commands::Changes.command(c) ; end
	# p.command(:lsch)    do |c| Confetti::Commands::LsCh.command(c) ; end

 	p.command(:help) do |c|
		c.syntax 'help'
		c.description 'prints help'
		c.action do |args, options| puts p; end
	end

	p.default_command :help
end
