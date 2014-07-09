
require 'minitest/autorun'
require '../lib/Confetti.rb'
require 'byebug'

module Confetti

CONFETTI_TEST = 1

end

class Test1 < Minitest::Test

	def setup
		byebug
		@db = Confetti::DB.global
	end
	
	def teardown
#		byebug
#		@db.cleanup
	end

	def test_project_names
		puts @db.path
		assert_equal %w(main ucgw-7.7 ucgw-8.0 mcu-7.7 mcu-8.0 test).sort, @db["select * from projects"].map { |p| p[:name] }.sort
	end
end
