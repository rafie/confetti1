
require 'minitest/autorun'
require 'Test.rb'
require 'View.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class Test1 < Confetti::Test

	def keep?; false; end

	def before
	end

	def after
	end

	def after_cleanup
		if !keep?
			raise "failed in cleanup, Test1: #{@path}" if File.directory?(root)
			FileUtils.rm_r(root) rescue ''
		end
		raise "current_test is not nil" if Confetti::Test.current != nil
	end

	def test_confetti_test
		assert_equal true, Confetti::TEST_MODE
		# assert_equal self, Confetti::Test.current
	end

	def test_testdir_exists
		assert_equal true, File.directory?(root)
	end

end

#----------------------------------------------------------------------------------------------

class Test2 < Confetti::Test

	def keep?; true; end

	def after_cleanup
		raise "failed to keep test directory, Test2: #{root}" if !File.directory?(root)
		FileUtils.rm_r(root) rescue ''
		raise "current_test is not nil" if Confetti::Test.current != nil
	end

	def test_confetti_test
		assert_equal true, Confetti::TEST_MODE
#		assert_equal self, Confetti::Test.current
	end

	def test_testdir_exists
		assert_equal true, File.directory?(root)
	end

end

#----------------------------------------------------------------------------------------------

if Confetti::CONFETTI_CLEARCASE

#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def create_vob?; true; end

	def before
		@@vob_name = root_vob.name
		@@view = ClearCASE::View.create('', root_vob: root_vob)
	end

	def after
		@@view.remove!
	end

	def after_cleanup
		raise "VOB #{@@vob_name} not removed" if ClearCASE.VOB(@@vob_name).exist?
	end

	def test_vob
		assert_equal true, File.directory?(@@view.path + '/rvfc')
	end
end

#----------------------------------------------------------------------------------------------

class Test4 < Confetti::Test

	def create_vob?; true; end

	def before
		@@vob_name = root_vob.name
		@@view = Confetti::View.create('')
	end

	def after
		@@view.remove!
	end

	def test_vob
		assert_equal true, File.directory?(@@view.path + '/rvfc')
	end
end

#----------------------------------------------------------------------------------------------

end # Confetti::CONFETTI_CLEARCASE

#----------------------------------------------------------------------------------------------
