
require 'minitest/autorun'
require 'Confetti/lib/Test.rb'
require 'Confetti/lib/View.rb'
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

if Confetti::TEST_WITH_CLEARCASE

#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def create_vob?; true; end

	def setup
		@vob_name = @root_vob.name
		@view = ClearCASE::View.create('', root_vob: root_vob)
	end

	def teardown
		super()
		raise "VOB #{@vob_name} not removed" if ClearCASE.VOB(@vob_name).exist?
		@view.remove!
	end

	def test_vob
		assert_equal true, File.directory?(@view.path + '/rvfc')
	end
end

#----------------------------------------------------------------------------------------------

class Test4 < Confetti::Test

	def create_vob?; true; end

	def setup
		@vob_name = @root_vob.name
		@view = Confetti::View.create('')
	end

	def teardown
		super()
		@view.remove!
	end

	def test_vob
		assert_equal true, File.directory?(@view.path + '/rvfc')
	end
end

#----------------------------------------------------------------------------------------------

end # Confetti::TEST_WITH_CLEARCASE

#----------------------------------------------------------------------------------------------
