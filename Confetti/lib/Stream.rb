
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

# (stream strean-name
# 	(baseline
#		cspec)
# 
# 	:icheck N
# 	:itag N
# 	
# 	(lots
# 		lot-names ...)
# 	
# 	(products
# 		(product product-name :lot product-lot))
# )

class StreamSpec
	def is(text, *opt)
		@ne = Nexp::Nexp.from_string(text, :single)
	end

	def from_file(fname, *opt)
		@ne = Nexp::Nexp.from_file(fname, :single)
	end

	#-------------------------------------------------------------------------------------------

	def to_s
		@ne.text
	end

	def nexp
		@ne
	end

	#-------------------------------------------------------------------------------------------

	private :is, :from_file
	private_class_method :new
end # class StreamSpec

def self.StreamSpec(*args)
	x = StreamSpec.send(:new); x.send(:is, *args); x
end

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
