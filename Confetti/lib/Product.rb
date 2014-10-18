
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Product
	include Bento::Class

	constructors :is, :create
	members :id, :project

	def is(version, *opt, project: nil)
		raise "invalid project" if !project
	end

	def create(name, *opt, project: nil)
		raise "invalid project" if !project
	end

end

#----------------------------------------------------------------------------------------------

end
