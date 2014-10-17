
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class LsProj
	def LsProj.command(c)
		c.syntax = 'tt lsproj [options]'
		c.summary = 'List activities'
		c.description = c.summary

		c.example 'List all projects', 'tt lsproj'

		c.action LsProj
	end

	def initialize(args, options)
		
	end
end

end # Commands
end # Confetti
