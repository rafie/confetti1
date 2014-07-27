
require 'minitest/autorun'
require 'Bento'
require '../lib/Test.rb'
require '../lib/LSpec.rb'
require '../lib/Lot.rb'

class Lot1 < Confetti::Test

	def create_fs?; false; end
	def create_vob?; false; end

	def setup
		@lspec = Confetti::LSpec.from_file('lot1.lspec')
	end

	def test_enum_lots
		lots = Confetti::Lots.new(nil, lspec: @lspec)
		assert_equal %w(nbu.mcu nbu.web nbu.media nbu.dsp nbu.infra nbu.contrib nbu.build nbu.bsp nbu.tests).sort,
			lots.names.sort
		assert_equal lots.count, 9
	end

	def test_lot_vobs
		mcu = Confetti.Lot('nbu.mcu', lspec: @lspec)
		assert_equal 'nbu.mcu', mcu.name
		assert_equal %w(adapters dialingInfo mcu mediaCtrlInfo).sort, mcu.vobs.names.sort
	end

	def test_lot_lots
		media = Confetti.Lot('nbu.media', lspec: @lspec)
		assert_equal %w(nbu.dsp nbu.infra nbu.bsp nbu.contrib nbu.build nbu.tests).sort, media.lots.names.sort
	end
end
