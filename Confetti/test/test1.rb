
require 'minitest/autorun'
require 'Confetti/lib/Test.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class Test1 < Confetti::Test

	def keep?; false; end

	def setup
	end
	
	def teardown
		super()
		raise "failed in cleanup, Test1: #{@path}" if File.directory?(@path)
		FileUtils.rm_r(@path) rescue ''
		raise "current_test is not nil" if Confetti::Test.current != nil
	end

	def test_confetti_test
		assert_equal 1, Confetti::TEST_MODE
		assert_equal self, Confetti::Test.current
	end

	def test_testdir_exists
		assert_equal true, File.directory?(@path)
	end

end

#----------------------------------------------------------------------------------------------

class Test2 < Confetti::Test

	def keep?; true; end

	def setup
	end
	
	def teardown
		super()
		raise "failed to keep test directory, Test2: #{@path}" if !File.directory?(@path)
		FileUtils.rm_r(@path) rescue ''
		raise "current_test is not nil" if Confetti::Test.current != nil
	end

	def test_confetti_test
		assert_equal 1, Confetti::TEST_MODE
		assert_equal self, Confetti::Test.current
	end
	
	def test_testdir_exists
		assert_equal true, File.directory?(@path)
	end

end

#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def keep?; true; end

	def setup
	end

	def test_db_1
		db = Confetti::DB.global
		assert_equal Confetti::Test::current.path + '/net/confetti/global.db', db.path
	end
end
	
#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def keep?; true; end

	def setup
	end

	def test_db_2
		db = Confetti::DB.global
		assert_equal Confetti::Test::current.path + '/net/confetti/global.db', db.path
	end
end
	
#----------------------------------------------------------------------------------------------
