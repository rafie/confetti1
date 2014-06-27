
require 'minitest/autorun'
require '../lib/Lot.rb'

module Confetti

CONFETTI_TEST = 1

end

class Lot1 < Minitest::Test

	def setup
		@x = Nexp.from_file("view/nbu.meta/confetti/lots.ne", :single)
#		names = x.cdr.each(:lot) { |lot| ~lot.cadr } # (lot name ...)
		@lots = Confetti::Lots.new
		mcu = Confetti::Lot.new('nbu.mcu')
		a = 1
	end
	
	def test_enum_lots
		assert_equal @lots.count, 11
	end

	def test_lot
		mcu = Confetti::Lot.new('nbu.mcu')
		bb
		assert_equal mcu.name, 'nbu.mcu'
		assert_equal mcu.vobs.map {|x| x.name}.sort, %w(adapters dialingInfo mcu mediaCtrlInfo nbu.proto.jingle-stack)

		nbu_prod_mcu = Confetti::Lot.new('nbu.prod.mcu')
		assert_equal nbu_prod_mcu.lots.map {|x| x.name}.sort, %w(nbu.bsp nbu.dsp nbu.infra nbu.mcu nbu.media nbu.tests nbu.tools nbu.web)
	end
	
end
