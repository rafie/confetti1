
require 'minitest/autorun'
require '../lib/Confetti.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class Test1 < Confetti::Test

	def setup
		@db = Confetti::DB.global
	end
	
	def test_project_names
		puts @db.path
		assert_equal %w(main ucgw-7.7 ucgw-8.0 mcu-7.7 mcu-8.0 test).sort, @db["select * from projects"].map { |p| p[:name] }.sort
	end
end

#----------------------------------------------------------------------------------------------
