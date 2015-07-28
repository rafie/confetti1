
require 'mercenary'

require 'Confetti'

module Confetti
module Commands
module __Commands__

#----------------------------------------------------------------------------------------------

def self.__command__(c)
	c.syntax '__command__ [options] [arguments]'
	c.description '...'

	c.option :__option__, '-o', '--option', 'description'

	c.action do |args, options|
	end
end # __command__

#----------------------------------------------------------------------------------------------

def self.commands(c)
	c.syntax '__commands__ [options] command [arguments]'
	c.description 'box commands'

	c.option :__option__, '-o', '--option', 'description'

	c.command :__command__ do |c| __command__(c) ; end

end

#----------------------------------------------------------------------------------------------

end # __Command__
end # Commands
end # Confetti
