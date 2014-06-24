
require 'minitest/autorun'
require '../lib/Lot.rb'

class Lot1 < Minitest::Test

	def setup
		@lots = Confetti.Lots.new
#		byebug
	end
	
	def test_enum_lots
		n = 0
		@lots.each { |x| ++n }
		assert n > 0, "no lots"
	end
end