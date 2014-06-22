
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class __Commnad__
	def __Commnad__.command(c)
		c.syntax = 'tt command [options]'
		c.summary = ''
		c.description = c.summary

		c.example 'description', 'command'

		c.option '--option', 'description'

		c.action __Commnad__
	end

	def initialize(args, options)
	end
end

end # Commands
end # Confetti
