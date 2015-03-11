
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class MkProd
	def MkProj.command(c)
		c.syntax = 'tt mkprod [options]'
		c.summary = 'Create a new product'
		c.description = ''
		c.example 'description', 'command example'
		c.option '--some-switch', 'Some switch that does something'

		c.action MkProd
	end

	def initialize(args, options)
		flags = []

		byebug
		name = args.shift
		name = options.name if !name && !!options.name
		raise "missing product name" if !name
		raise "missing project name" if !options.project

		project = options.project if 

		flags << :raw if options.raw

		say "Creating product #{name} ..."
		
		prod = Confetti::Product.create(name, *flags, project: project)

		say "product #{name} created."
	end
end

end # Commands
end # Confetti
