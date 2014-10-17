
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class MkVer
	def MkVer.command(c)
		c.syntax = 'tt mkver [options]'
		c.summary = 'Create a new project version'
		c.description = ''
		c.example 'description', 'command example'
		c.option '--some-switch', 'Some switch that does something'

		c.action MkVer
	end

	def initialize(args, options)
	end
end

end # Commands
end # Confetti
