require 'minitest/autorun'
require '../lib/CSpec.rb'

module Confetti

CONFETTI_TEST = 1

end

class CSpec1 < Minitest::Test

	@@nexp = <<END
(cspec
	:tag nbu.mcu-8.3.1.3.5
	:stem nbu.mcu-8.3
	(lots
		nbu.mcu
		(nbu.web     WebMcu_8.3_1_SP1_1_240314.5628)
		(nbu.media   nbu.media_8.3.1.3.2)
		(nbu.dsp     nbu.dsp_8.3.1.3.5.0)
		(nbu.bsp     nbu.dsp_1.0.0.7.9)
		(nbu.infra   nbu.infra_mcu-8.0_3.0)
		(nbu.contrib nbu.contrib_mcu-8.3.1.3.0)
		(nbu.tests   nbu.tests_1.7.3)
		(nbu.build   nbu.build_1.4.19)
	)
	(checks 16 17 18)
)
END

	@@configspec = <<END
END

	def setup
		@cspec = Confetti::CSpec.new(@@nexp)
	end

	def test_basics
		byebug
		assert_equal 'nbu.mcu-8.3.1.3.5', @cspec.tag
		assert_equal 'nbu.mcu-8.3', @cspec.stem
		assert_equal %w(nbu.bsp nbu.build nbu.contrib nbu.dsp nbu.infra nbu.mcu nbu.media nbu.tests nbu.web), @cspec.lots.sort
		assert_equal [16, 17, 18], @cspec.checks
	end

#	def test_configspec
end
