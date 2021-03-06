
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class User
	attr_reader :name

	def initialize(name)
		@name = name.to_s.downcase
	end

	def to_s
		@name
	end

#	def self.current
#		User.new(System.user)
#	end
end # User

#----------------------------------------------------------------------------------------------

class CurrentUser < User

	def initialize
		super(System.user)
	end

end

#----------------------------------------------------------------------------------------------

end # module Confetti
