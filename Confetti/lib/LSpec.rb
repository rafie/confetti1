
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
		@nexp = NExp.from_s(text, :single)
	end

	def from_file(fname, *opt)
		@nexp = Nexp(fname, :single)
		raise "invalid lspec file: #{fname}" if ~@nexp[0] != "lots"
	end

	#-------------------------------------------------------------------------------------------

	def to_s
		nexp.text
	end

	def nexp
		@nexp
	end

	def lots
		Hash[nexp[:lots].map {|lot| [~lot.car, OpenStruct.new(:vobs => ~lot[:vobs], :lots => ~lot[:lots])]}]
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
