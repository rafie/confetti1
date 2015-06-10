
require 'mercenary'

require 'Confetti'

module Confetti
module Commands

#----------------------------------------------------------------------------------------------

def self.mkact(c)
	c.syntax 'mkact [options] name'
	c.description 'Create a new activity'

	c.option :__option__, '-o', '--option', 'description'

	c.option :name, '--name NAME', 'Activity name'
	c.option :project, '--project NAME', 'Project name'
	c.option :raw, '--raw', 'Do not add username prefix'

	c.action do |args, options|
		flags = []

		byebug
		name = args.shift
		name = options.name if !name && !!options.name
		raise "missing activity name" if !name

		project = options.project
		raise "missing project name" if !project

		flags << :raw if options.raw

		puts "Creating activity #{name} ..."

		act = Confetti::Activity.create(name, *flags, project: Confetti.Project(project))

		puts "Activity #{name} created."
	end
end # __command__

#----------------------------------------------------------------------------------------------

end # Commands
end # Confetti
