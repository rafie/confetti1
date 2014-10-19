
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

		@@config_t = <<-END
(project <%= @name %>
	(baseline 
		<%= @baseline_cspec.to_s %>)
	:itag 0
	:icheck 0
	(lots 
		<%for lot in @lots %> <%= lot %> <% end %>))
END

	@@configspec_t = <<END
(cspec
	(vobs
<%for vob in @vobs_cfg.keys %>
		(<%= vob %> <%= @vobs_cfg[vob] %>)
<% end %>
	)
)
END

	constructors :is, :from_file
	members :ne, [:lspec, :opt]

	attr_accessor :lspec

	def is(text, *opt, lspec: nil)
		@ne = NExp.from_s(text, :single)
		ctor(*opt, lspec)
	end

	def from_file(fname, *opt, lspec: nil)
		@ne = Nexp(fname, :single)
		ctor(*opt, lspec)
	end

	def from_configspec(configspec, *opt)
		vobs_cfg = configspec.vobs_cfg
		cspec_s = Bento.mold(@@config_t, binding)
		@ne = NExp.from_s(cspec_s, :single)
		ctor(*opt, nil)
	end

	def ctor(*opt, lspec)
		@lspec = lspec if lspec
	end

	private :ctor

	#-------------------------------------------------------------------------------------------

	def to_s
		@ne.text
	end

	def nexp
		@ne
	end

	def configspec(lspec: nil, branch: nil)
		tag = self.tag

		vobs_cfg = self.vobs_cfg
		lots_cfg = self.lots_cfg

		lspec = @lspec if lspec == nil
		if lspec != nil
			lots_cfg.keys.each do |lot_name|
				lot = Confetti.Lot(lot_name, lspec: @lspec)
				lot_vobs = lot.vobs
				lot_vobs.each do |vob|
					vob_tag = lots_cfg[lot_name]
					vob_tag = tag if vob_tag.empty?
					vobs_cfg[vob.name] = vob_tag
				end
			end
		end

		checks_tags = checks.map {|c| stem + "_check_" + c.to_s}
		ClearCASE.Configspec(vobs_cfg: vobs_cfg, tag: tag, checks: checks_tags, branch: branch)
	end

	# TODO: allow vob tags
	def tag(lot: '')
		if lot == ''
			t = ~nexp[:tag]
		else
			t = lots_cfg[lot]
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
		ClearCASE::VOBs.new(nexp.nodes(:vobs).map {|x| ~x.car })
	end

	def vobs_cfg
		Hash[ nexp[:vobs].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def add_vob(vob, tag)
		nexp.find(:vobs) << [vob, tag]
	end

	def lots
		Confetti::Lots.new(nexp.nodes(:lots).map {|x| ~x.car }, lspec: @lspec)
	end

	def lots_cfg
		Hash[ nexp[:lots].map {|x| [~x.car, ~x.cdr == [] ? '' : ~x.cadr] } ]
	end

	def checks
		nexp[:checks].map { |x| x.to_i }
	end

	def add_check(n)
		nexp.find(:checks) << n
	end

	# TODO: return a flat cspec, without lot tags, just basic repos
	def flat
		raise "unimplemented"
	end

	# TODO
	def flat?
		# are there any lot tags?
	end

end # CSpec

#----------------------------------------------------------------------------------------------

end # module Confetti
