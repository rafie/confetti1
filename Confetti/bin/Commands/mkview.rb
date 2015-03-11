
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class MkView
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
