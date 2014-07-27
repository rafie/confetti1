
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

class Stream

	def is(name, *opt)
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	private :is
	private_class_method :new

end # class Stream

def self.Stream(*args)
	x = Stream.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
