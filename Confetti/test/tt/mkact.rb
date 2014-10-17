
require 'minitest/autorun'
require 'Test.rb'

#----------------------------------------------------------------------------------------------

class MkAct1 < Confetti::Test

#	def create_vob?; true; end

	@@configspec_t = <<END
END
	
	def after_cleanup
		Confetti::View('act1').remove!
	end

	def tt(*args)
		System.command("tt " + args.join(" "))
	end

	def test_create1
		assert_equal 0, tt("mkact --project mcu-8.0 --name act1").retval
		_test("act1")
	end

	def test_create1
		assert_equal 0, tt("mkact --project mcu-8.0 act2").retval
		_test("act2")
	end
	
	def _test(act)
		assert_equal true, Confetti.View(act).exist?
		assert_equal true, Confetti.Branch(act).exist?
		
		# check view
		# check branch
		# check configspec
	end
end
