
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

# (cspec 
#   :tag tag1
#   :stem stem
#   (vobs
#		(vob1 tag2))
# 	(lots
# 		lot1
# 		(lot2 tag3)
# 	)
#   (checks 10 11 12) # yields tags like stem_check_10
# )

# :tag specifies a global tag over all vobs
# :stem specifies prefix of checks
# checks specify partial labels in ascending times order (oldest first)
# lot tags apply on lots what are possibly unmarked by global tag

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

	@@configspec_t = <<-END
END

	# constructors :is, :from_file
	# members :@ne

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

	def configspec
		raise "unimplemented"
	end

	def tag(lot = '')
		if lot == ''
			t = ~nexp[:tag]
		else
			t = lots[lot]
			t = ~nexp[:tag] if t == ''
		end
		t
	end

	def tag=(t)
		nexp[:tag] = t
	end

	def stem
		~nexp[:stem]
	end

	def lots
		Hash[ nexp[:lots].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def checks
		nexp[:checks].map { |x| x.to_i }
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
end # CSpec

def self.CSpec(*args)
	x = CSpec.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
