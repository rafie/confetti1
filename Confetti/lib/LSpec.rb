
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

# (lots 
#   (lot1
#     (vobs
#       vob1 vob2 ...))
#     (lots
#       lot3 lot4 ...))
# )

# Q: should we support lot-to-lot dependencies or rather project to specify its lots?

class LSpec
	include Bento::Class

	def is(text, *opt)
		@ne = Nexp::Nexp.from_string(text, :single)
	end

	def from_file(fname, *opt)
		@ne = Nexp::Nexp.from_file(fname, :single)
	end

	#-------------------------------------------------------------------------------------------

	def to_s
		nexp.text
	end

	def nexp
		@ne
	end

	def vobs
		Hash[ nexp[:vobs].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def lots
		Hash[ nexp[:lots].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.from_file(*args)
		x = self.send(:new); x.send(:from_file, *args); x
	end
	
	private :is, :from_file
	private_class_method :new
end # LSpec

def self.LSpec(*args)
	x = LSpec.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti