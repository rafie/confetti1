
require 'mercenary'

require 'Confetti'

module Confetti
module Commands
module Dev

#----------------------------------------------------------------------------------------------

def self.deploy(c)
	c.syntax 'deploy [options] [arguments]'
	c.description 'Merge version to integration (master) branch'

	c.option :message, '-m MSG', '--message MSG', 'description'

	c.action do |args, options|
		ws = Confetti.Workspace()
		bb
		ws.deploy(nil, options[:message])
	end
end # deploy

#----------------------------------------------------------------------------------------------

def self.rebase(c)
	c.syntax 'rebase [options] [arguments]'
	c.description 'Rebase development workspace'

#	c.option :__option__, '-o', '--option', 'description'

	c.action do |args, options|
		ws = Confetti.Workspace()
		ws.rebase
	end
end # rebase

#----------------------------------------------------------------------------------------------

def self.release(c)
	c.syntax 'release [options] [arguments]'
	c.description 'Create version on production branch and update production site'

#	c.option :__option__, '-o', '--option', 'description'

	c.action do |args, options|
	end
end # release

#----------------------------------------------------------------------------------------------

def self.commands(c)
	c.syntax 'dev command [options] [arguments]'
	c.description 'Confetti development operations'

#	c.option :__option__, '-o', '--option', 'description'

	c.command :deploy  do |c| deploy(c) ; end
	c.command :rebase  do |c| rebase(c) ; end
	c.command :release do |c| release(c) ; end

end

#----------------------------------------------------------------------------------------------

end # Dev
end # Commands
end # Confetti
