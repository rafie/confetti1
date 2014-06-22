
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class LsAct
	def LsAct.command(c)
		c.syntax = 'tt lsact [options]'
		c.summary = 'List activities'
		c.description = c.summary

		c.example 'List all activities', 'tt lsact'
		c.example 'List my activities', 'tt lsact --my'
		c.example "List user's activities", 'tt lsact --user jojo'
		c.example "List activities of project", 'tt lsact --project p1'

		c.option '--my', 'List my activities'
		c.option '--user USER', "List USER's activities"
		c.option '--project PROJECT', "List activities of PROJECT"

		c.action LsAct
	end

	def initialize(args, options)
		
	end
end

end # Commands
end # Confetti
