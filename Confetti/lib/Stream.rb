
require_relative 'Common'

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
	include Bento::Class
	
	constructors :is, :from_file
	members :ne

	def is(text, *opt)
		@ne = NExp.from_s(text, :single)
	end

	def from_file(fname, *opt)
		@ne = Nexp(fname, :single)
	end

	#-------------------------------------------------------------------------------------------

	def to_s
		@ne.text
	end

	def nexp
		@ne
	end

end # class StreamSpec

#----------------------------------------------------------------------------------------------

class Stream
	include Bento::Class
	
	constructors :is
	members :ne

	def is(name, *opt)
	end

	#-------------------------------------------------------------------------------------------

end # class Stream

#----------------------------------------------------------------------------------------------

end # module Confetti
