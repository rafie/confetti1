
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

class Branch

	attr_reader :name

	def is(name, *opt)
		@name = name.to_s
	end

	def create(name, *opt, stream: nil)
		raise "unimplemented"

		raise "invalid stream specification" if !stream
		@name = name.to_s
	end

	#-------------------------------------------------------------------------------------------

	def to_s; name; end
	def to_str; name; end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	private :is, :create
	private_class_method :new

end # class Stream

def self.Branch(*args)
	x = Branch.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
