
require 'minitest/autorun'
require '../lib/Lot.rb'

module Confetti

CONFETTI_TEST = 1

end

class Lot1 < Minitest::Test

	def setup
		x = Nexp.from_file("view/nbu.meta/confetti/lots.ne", :single)
#		names = x.cdr.each(:lot) { |lot| ~lot.cadr } # (lot name ...)
		byebug
		@lots = Confetti::Lots.new
		mcu = Confetti::Lot.new('nbu.mcu')
		a = 1
	end
	
	def test_enum_lots
		assert_equal @lots.count, 11
	end

	def test_lot
		mcu = Confetti::Lot.new('nbu.mcu')
		assert_equal mcu.name, 'nbu.mcu'
		assert_equal mcu.vobs.to_a, %w(nbu.mcu nbu.web nbu.media nbu.dsp nbu.infra nbu.bsp nbu.tools nbu.tests)
	end
	
end
