
require_relative 'Common'
require_relative 'Lot'

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

	def configspec(lspec: nil)
		checks1 = checks.map {|c| stem + "_check_" + c.to_s }
		lots1 = lots
		vobs1 = vobs
		tag1 = tag
		if lspec != nil
			lots1.keys.each do |lot|
				lot1 = Confetti.Lot(lot, lspec: lspec)
				lot_vobs = lot1.vobs
				lot_vobs.each do |vob|
					vob1 = vob.to_s
					vob_tag = lots1[lot]
					vob_tag = tag1 if vob_tag.empty?
					vobs1[vob] = vob_tag
				end
			end
		end
		ClearCASE.Configspec(vobs: vobs1, tag: tag, checks: checks1)
	end

	# TODO: allow vob tags
	def tag(lot: '')
		if lot == ''
			t = ~nexp[:tag]
		else
			t = lots[lot]
			t = ~nexp[:tag] if t == ''
		end
		t.empty? ? nil : t
	end

	def tag=(t)
		nexp[:tag] = t
	end

	def stem
		~nexp[:stem]
	end

	def stem=(s)
		nexp[:stem] = s
	end

	def vobs
		Confetti.VOBs.new(nexp.nodes(:vobs))
	end

	def vobs_cfg
		Hash[ nexp[:vobs].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end
	
	def lots
		nexp.nodes(:lots)
	end

	def lots_cfg
		Hash[ nexp[:lots].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def checks
		nexp[:checks].map { |x| x.to_i }
	end

end # CSpec

#----------------------------------------------------------------------------------------------

end # module Confetti
