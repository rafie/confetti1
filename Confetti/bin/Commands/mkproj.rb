
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class MkProj
	def MkProj.command(c)
		c.syntax = 'tt mkproj [options]'
		c.summary = 'Create a new project'
		c.description = ''
		c.example 'description', 'command example'
		c.option '--some-switch', 'Some switch that does something'

		c.action MkProj
	end

	def initialize(args, options)
		flags = []

		byebug
		name = args.shift
		name = options.name if !name && !!options.name
		raise "missing project name" if !name

		branch = options.branch if !!options.branch

		cspec = options.cspec if !!options.cspec

		project = options.project if !!options.project

		version = options.version if !!options.version

		raise "missing cspec file or project to copy" if !options.project && !options.cspec

		raise "specify either project or cspec file" if options.project && options.cspec

		flags << :raw if options.raw

		say "Creating project #{name} ..."
		
		proj = Confetti::Project.create(name, *flags, branch: branch,cspec: cspec, lspec: nil) if options.cspec

		proj = Confetti::Project.create_from_project(name, *flags, branch: branch,from_project: project) if options.project

		say "Project #{name} created."
	end
end

end # Commands
end # Confetti
