
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

	constructors :is, :from_file
	members :nexp

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

	def s_to_a(x)
		x.respond_to?(:each) ? x : [x]
	end
	private :s_to_a

	def lots
		Hash[nexp[:lots].map {|lot| [~lot.car, 
			OpenStruct.new(:vobs => ~lot.nodes(:vobs), :lots => ~lot.nodes(:lots))]}]
	end

end # LSpec

#----------------------------------------------------------------------------------------------

end # module Confetti
