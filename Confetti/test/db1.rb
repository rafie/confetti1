
require 'minitest/autorun'
require '../lib/Test.rb'
require '../lib/Confetti.rb'

#----------------------------------------------------------------------------------------------

class Test1 < Confetti::Test

	def before
		@@db = Confetti::DB.global
	end
	
	def test_project_names
		assert_equal %w(ucgw-7.7 mcu-8.0 mcu-8.3).sort, @@db["select * from projects"].map { |p| p[:name] }.sort
	end
end

#----------------------------------------------------------------------------------------------

class Test2 < Confetti::Test

	def test_is_the_right_db
		db = Confetti::DB.global
		assert_equal Confetti::Test.root + '/net/confetti/global.db', db.path
	end
end
	
#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def test_is_the_right_db
		db = Confetti::DB.global
		assert_equal Confetti::Test.root + '/net/confetti/global.db', db.path
	end
end
	
#----------------------------------------------------------------------------------------------
