require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class View
	attr_reader :name

	def initialize(name)
		@name = name
	end

	def View.create(name)
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
