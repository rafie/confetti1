
require 'minitest/autorun'

require 'Confetti/lib/Test.rb'
require 'CSpec.rb'

#----------------------------------------------------------------------------------------------

class CSpec1 < Confetti::Test

	def create_fs?; false; end
	def create_vob?; false; end

	@@nexp = <<END
(cspec
	:tag nbu.mcu-8.3.1.3.5
	:stem nbu.mcu-8.3
	(lots
		nbu.mcu
		(nbu.web     WebMcu_8.3_1_SP1_1_240314.5628)
		(nbu.media   nbu.media_8.3.1.3.2)
		(nbu.dsp     nbu.dsp_8.3.1.3.5.0)
		(nbu.bsp     nbu.bsp_1.0.0.7.9)
		(nbu.infra   nbu.infra_mcu-8.0_3.0)
		(nbu.contrib nbu.contrib_mcu-8.3.1.3.0)
		(nbu.tests   nbu.tests_1.7.3)
		(nbu.build   nbu.build_1.4.19)
	)
	(checks 16 17 18))
END

	@@configspec = <<END
element /mcu/...                     nbu.mcu-8.3.1.3.5
element /adapters/...                nbu.mcu-8.3.1.3.5
element /dialingInfo/...             nbu.mcu-8.3.1.3.5   
element /mediaCtrlInfo/...           nbu.mcu-8.3.1.3.5
element /nbu.proto.jingle-stack/...  nbu.mcu-8.3.1.3.5

element /web/...                     WebMcu_8.3_1_SP1_1_240314.5628

element /nbu.media/...               nbu.media_8.3.1.3.2
element /mvp/...                     nbu.media_8.3.1.3.2
element /mpc/...                     nbu.media_8.3.1.3.2
element /map/...                     nbu.media_8.3.1.3.2
element /mf/...                      nbu.media_8.3.1.3.2
element /mpInfra/...                 nbu.media_8.3.1.3.2
element /NBU_FEC/...                 nbu.media_8.3.1.3.2
element /NBU_RTP_RTCP_STACK/...      nbu.media_8.3.1.3.2
element /NBU_ICE/...                 nbu.media_8.3.1.3.2

element /dspIcsVideo/...             nbu.dsp_8.3.1.3.5.0
element /dspInfra/...                nbu.dsp_8.3.1.3.5.0
element /dspIntelInfra/...           nbu.dsp_8.3.1.3.5.0
element /dspNetraInfra/...           nbu.dsp_8.3.1.3.5.0
element /dspNetraVideo/...           nbu.dsp_8.3.1.3.5.0
element /dspUCGW/...                 nbu.dsp_8.3.1.3.5.0
element /mpDsp/...                   nbu.dsp_8.3.1.3.5.0
element /NetraVideoCODEC/...         nbu.dsp_8.3.1.3.5.0
element /swAudioCodecs/...           nbu.dsp_8.3.1.3.5.0

element /nbu.infra/...               nbu.infra_mcu-8.0_3.0
element /boardInfra/...              nbu.infra_mcu-8.0_3.0
element /configInfra/...             nbu.infra_mcu-8.0_3.0
element /swInfra/...                 nbu.infra_mcu-8.0_3.0
element /loggerInfra/...             nbu.infra_mcu-8.0_3.0
element /rvfc/...                    nbu.infra_mcu-8.0_3.0

element /nbu.contrib/...             nbu.contrib_mcu-8.3.1.3.0
element /NBU_COMMON_CORE/...         nbu.contrib_mcu-8.3.1.3.0
element /NBU_SIP_STACK/...           nbu.contrib_mcu-8.3.1.3.0
element /NBU_H323_STACK/...          nbu.contrib_mcu-8.3.1.3.0

element /freemasonBuild/...          nbu.build_1.4.19

element /bspLinuxIntel/...           nbu.bsp_1.0.0.7.9
element /bspLinuxARM/...             nbu.bsp_1.0.0.7.9

element /nbu.test/...                nbu.tests_1.7.3
END

	def before
		@@cspec = Confetti.CSpec(@@nexp)
	end

	def test_basics
		cspec = @@cspec
		assert_equal 'nbu.mcu-8.3.1.3.5', cspec.tag
		assert_equal 'nbu.mcu-8.3', cspec.stem
		assert_equal %w(nbu.bsp nbu.build nbu.contrib nbu.dsp nbu.infra nbu.mcu nbu.media nbu.tests nbu.web), cspec.lots.keys.sort
		assert_equal [16, 17, 18], cspec.checks
		assert_equal 'nbu.bsp_1.0.0.7.9', cspec.tag('nbu.bsp')
	end

	def test_mods
		skip "Node.[]= is broken"
		@@cspec.tag = 'nbu.mcu-8.3.1.4.0'
		assert_equal 'nbu.mcu-8.3.1.4.0', @@cspec.tag
	end

	def test_cspec
		assert_equal @@nexp.strip, @@cspec.to_s
	end

	def test_configspec
		skip "unimplemented"
		assert_equal @@configspec, @@cspec.configspec
	end
end

#----------------------------------------------------------------------------------------------

class CSpec2  < Confetti::Test

	def create_fs?; false; end
	def create_vob?; false; end

	@@nexp = <<END
(cspec
	:stem nbu.mcu-8.3
	(vobs
		(mcu            nbu.mcu-8.3.1.3.5)
		(adapters       nbu.mcu-8.3.1.3.5)
		(mvp            nbu.media_8.3.1.3.2)
		(dspInfra       nbu.dsp_8.3.1.3.5.0)
		(boardInfra     nbu.infra_mcu-8.0_3.0)
		(freemasonBuild nbu.build_1.4.19)))
END

	def test_vobs
	end
	
	def test_configspec
	end
end

#----------------------------------------------------------------------------------------------
