
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

# (cspec 
#   :tag tag1
#   :stem stem
# 	(lots
# 		lot1
# 		(lot2 tag2)
# 	)
#   (checks 10 11 12) # yields tags like stem_check_10
# )

### translated into configspec:

# element * stem_check_12
# element * stem_check_11
# element * stem_check_10
#
# element * tag1
#
# element /lot2_vob1-1/... tag2 # rest of VOBs follow

class CSpec
	include Bento::Class

	@@configspec_t = ERB.new <<-END
END

	def initialize(text, *opt)
		return if tagged_init(:from_file, opt, [text, *opt])

		@ne = Nexp::Nexp.from_string(text, :single)
	end

	def CSpec.from_file(fname)
		CSpec.new(fname, :from_file)
	end

	def to_s
		@ne.text
	end

	def db
		@ne
	end

	def configspec
	end

	def tag(lot = '')
		if lot == ''
			t = ~db[:tag]
		else
			t = lots[lot]
			t = ~db[:tag] if t == ''
		end
		t
	end

	def tag=(t)
		db[:tag] = t
	end

	def stem
		~db[:stem]
	end

	def lots
		Hash[ db[:lots].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def checks
		db[:checks].map { |x| x.to_i }
	end

	private

	def from_file(fname, *opt)
		@ne = Nexp::Nexp.from_file(fname, :single)
	end

end # CSpec

#----------------------------------------------------------------------------------------------

end # module Confetti
