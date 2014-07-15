
require 'minitest/autorun'
require '../lib/Test.rb'
require '../lib/Lot.rb'

class Lot1 < Confetti::Test

	def test_enum_lots
		@lots = Confetti::All::Lots.new
		assert_equal @lots.count, 11
	end

	def test_lot_vobs
		mcu = Confetti::Lot.new('nbu.mcu')
		assert_equal 'nbu.mcu', mcu.name
		assert_equal %w(adapters dialingInfo mcu mediaCtrlInfo).sort,
			mcu.vobs.map {|x| x.name}.sort

	end

	def test_lot_lots
		nbu_prod_mcu = Confetti::Lot.new('nbu.prod.mcu')
		assert_equal %w(nbu.bsp nbu.contrib nbu.dsp nbu.infra nbu.mcu nbu.media nbu.tests nbu.web).sort,
			nbu_prod_mcu.lots.map {|x| x.name}.sort
	end
end
