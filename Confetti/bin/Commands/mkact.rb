
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class MkAct
	def MkAct.command(c)
		c.syntax = 'tt mkact [options] name'
		c.summary = 'Create a new activity'
		c.description = 'Create a new activity'

		c.example "Create activity ACT for project PRJ", 'tt mkact --project PRJ ACT'
		c.example "Create activity ACT for project PRJ", 'tt mkact --name ACT --project PRJ'

		c.option '--name NAME', 'Activity name'
		c.option '--project NAME', 'Project name'
		c.option '--raw', 'Do not add username prefix'

		c.action MkAct
	end

	def initialize(args, options)
		flags = []

		byebug
		name = args.shift
		name = options.name if !name && !!options.name
		raise "missing activity name" if !name

		project = options.project
		raise "missing project name" if !project

		flags << :raw if options.raw

		say "Creating activity #{name} ..."

		act = Confetti::Activity.create(name, *flags, project: Confetti.Project(project))

		say "Activity #{name} created."
	end
end

end # Commands
end # Confetti
