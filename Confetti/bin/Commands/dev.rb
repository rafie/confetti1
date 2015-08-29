
require 'mercenary'

require 'Confetti'

module Confetti
module Commands
module Dev

#----------------------------------------------------------------------------------------------

def self.shell(c)
	c.syntax 'shell [options] [arguments]'
	c.description 'Open a development shell on the current Confetti view'

	c.action do |args, options|
		# system("cmd /k title Confetti Shell")
		ws = Confetti.Workspace()
		ws.shell()
	end
end # deploy

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

	c.option :dir, '--dir DIR', 'Production site directory'
	c.option :create, '--create', 'Create production site'

	c.action do |args, options|
		dir = options.dir
		
		if options.create
			site = Confett::Production.create(dir)
		else
			site = Confetti.Production(dir)
		end
		site.release()
	end
end # release

#----------------------------------------------------------------------------------------------

def self.commands(c)
	c.syntax 'dev command [options] [arguments]'
	c.description 'Confetti development operations'

#	c.option :__option__, '-o', '--option', 'description'

	c.command :shell   do |c| shell(c) ; end
	c.command :sh      do |c| shell(c) ; end
	c.command :deploy  do |c| deploy(c) ; end
	c.command :rebase  do |c| rebase(c) ; end
	c.command :release do |c| release(c) ; end

end

#----------------------------------------------------------------------------------------------

end # Dev
end # Commands
end # Confetti
