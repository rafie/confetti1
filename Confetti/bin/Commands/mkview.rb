
require 'mercenary'
require 'Confetti'

module Confetti
module Commands

class MkView

	Mercenary.program(:tt) do |p|
		p.version tt::VERSION
		p.description 'Confetti configuration manager'
		p.syntax "tt <subcommand> [options]"

		p.command(:mkview) do |c|
			c.syntax "mkview --name <view name> --project <project name> --version <project version> --cspec <configuration specification> --lspec <lot specification>"
			c.description "Create a view"
			c.option 'name', '-n','--name','Set the view name'
			c.option 'project', '-p','--project','Set project name for the view'
			c.option 'version', '-v','--ver','Set the version of the project. If ommited the latest version is considered'
			c.option 'cspec', '-c','--cspec','Set the cspec for the view definition'
			c.option 'lspec', '-l','--lspec','Set the lspec to be used'
			
			c.action do |_,options|
				
				
				view = Confetti::View.create(options.name,options.project,options.version,options.cspec,options.lspec)				
				
			end
		end
	end





	def MkView.command(c)
		c.syntax = 'tt mkview [options]'
		c.summary = 'Create a new view'
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
		raise "missing view name" if !name
		raise "missing cspec" if !options.cspec

		cspec = options.cspec

		flags << :raw if options.raw

		say "Creating view #{name} ..."
		
		view = Confetti::View.create(name, *flags, cspec: cspec)

		say "view #{name} created."
	end
end

end # Commands
end # Confetti
