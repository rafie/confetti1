
require 'minitest/autorun'

require 'Confetti/lib/Test'
require 'CSpec'
require 'LSpec'

#----------------------------------------------------------------------------------------------

class CSpecWithLots < Confetti::Test

	def create_fs?; false; end
	def create_vob?; false; end

	@@cspec_nexp = <<END
(cspec
	:tag nbu.mcu-8.3.1.3.5
	:stem nbu.mcu-8.3
	(lots
		nbu.mcu
		(nbu.web     WebMcu_8.3_1_SP1_1_240314.5628)
		(nbu.media   nbu.media_8.3.1.3.2)
		(nbu.dsp     nbu.dsp_8.3.1.3.5.0)
		(nbu.infra   nbu.infra_mcu-8.0_3.0)
		(nbu.contrib nbu.contrib_mcu-8.3.1.3.0)
		(nbu.build   nbu.build_1.4.19)
		(nbu.bsp     nbu.bsp_1.0.0.7.9)
		(nbu.tests   nbu.tests_1.7.3)
	)
	(checks 16 17 18))
END

	@@lspec_nexp = <<END
(lots
	(nbu.mcu
		(vobs mcu adapters dialingInfo mediaCtrlInfo))

	(nbu.web
		(vobs web))

	(nbu.media
		(vobs nbu.media mvp mpc map mf mpInfra NBU_FEC NBU_RTP_RTCP_STACK NBU_ICE swAudioCodecs))

	(nbu.dsp
		(vobs NetraVideoCODEC dspIcsVideo dspInfra dspIntelInfra dspNetraAudio dspNetraInfra dspNetraVideo mpDsp))

	(nbu.infra
		(vobs nbu.infra boardInfra configInfra swInfra loggerInfra rvfc))

	(nbu.contrib
		(vobs nbu.contrib NBU_COMMON_CORE NBU_SIP_STACK NBU_H323_STACK))
		
	(nbu.build
		(vobs freemasonBuild))

	(nbu.bsp
		(vobs bspLinuxIntel bspLinuxARM))

	(nbu.tests
		(vobs nbu.test)))
END

	@@configspec = <<END
element * CHECKEDOUT

element * nbu.mcu-8.3_check_18
element * nbu.mcu-8.3_check_17
element * nbu.mcu-8.3_check_16

element * nbu.mcu-8.3.1.3.5

element /mcu/...                     nbu.mcu-8.3.1.3.5
element /adapters/...                nbu.mcu-8.3.1.3.5
element /dialingInfo/...             nbu.mcu-8.3.1.3.5
element /mediaCtrlInfo/...           nbu.mcu-8.3.1.3.5

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
element /swAudioCodecs/...           nbu.media_8.3.1.3.2

element /NetraVideoCODEC/...         nbu.dsp_8.3.1.3.5.0
element /dspIcsVideo/...             nbu.dsp_8.3.1.3.5.0
element /dspInfra/...                nbu.dsp_8.3.1.3.5.0
element /dspIntelInfra/...           nbu.dsp_8.3.1.3.5.0
element /dspNetraAudio/...           nbu.dsp_8.3.1.3.5.0
element /dspNetraInfra/...           nbu.dsp_8.3.1.3.5.0
element /dspNetraVideo/...           nbu.dsp_8.3.1.3.5.0
element /mpDsp/...                   nbu.dsp_8.3.1.3.5.0

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

element * /main/0
END

	def before
		@@cspec = Confetti.CSpec(@@cspec_nexp)
		@@lspec = Confetti.LSpec(@@lspec_nexp)
		byebug
	end

	# not tested: tag= stem=, configspec()

	# tag, tag(lot)
	# stem
	# checks
	def test_basics
		cspec = @@cspec
		assert_equal 'nbu.mcu-8.3.1.3.5', cspec.tag
		assert_equal 'nbu.mcu-8.3', cspec.stem
		lot_names = %w(nbu.bsp nbu.build nbu.contrib nbu.dsp nbu.infra nbu.mcu nbu.media nbu.tests nbu.web)
		assert_equal lot_names, cspec.lots.names.sort
		assert_equal [16, 17, 18], cspec.checks
		assert_equal 'nbu.bsp_1.0.0.7.9', cspec.tag(lot: 'nbu.bsp')
	end

	# tag=
	def test_tag_set
		skip "Node.[]= is broken"
		@@cspec.tag = 'nbu.mcu-8.3.1.4.0'
		assert_equal 'nbu.mcu-8.3.1.4.0', @@cspec.tag
	end

	# stem=
	def test_stem_set
	end

	# configspec(lspec)
	def test_configspec
		assert_equal compact(@@configspec), compact(@@cspec.configspec(lspec: @@lspec).to_s)
	end

	def compact(s)
		Bento::Text.compact(s)
	end
end

#----------------------------------------------------------------------------------------------

class CSpecWithVOBs  < Confetti::Test

	def create_fs?; false; end
	def create_vob?; false; end

	@@cspec_nexp = <<END
(cspec
	:stem nbu.mcu-8.3
	(vobs
		(mcu            nbu.mcu-8.3.1.3.5)
		(adapters       nbu.mcu-8.3.1.3.4)
		(mvp            nbu.media_8.3.1.3.2)
		(dspInfra       nbu.dsp_8.3.1.3.5.0)
		(boardInfra     nbu.infra_mcu-8.0_3.0)
		(freemasonBuild nbu.build_1.4.19)))
END

	@@configspec = <<END
element * CHECKEDOUT

element /mcu/...            nbu.mcu-8.3.1.3.5
element /adapters/...       nbu.mcu-8.3.1.3.4
element /mvp/...            nbu.media_8.3.1.3.2
element /dspInfra/...       nbu.dsp_8.3.1.3.5.0
element /boardInfra/...     nbu.infra_mcu-8.0_3.0
element /freemasonBuild/... nbu.build_1.4.19

element * /main/0
END

	def test_vobs
#		assert_equal %w(adapters boardInfra dspInfra freemasonBuild mcu mvp), cspec.vobs.keys.sort
	end
	
	def test_configspec
#		assert_equal compact(@@configspec), compact(@@cspec_nexp.configspec.to_s)
	end
end

#----------------------------------------------------------------------------------------------
