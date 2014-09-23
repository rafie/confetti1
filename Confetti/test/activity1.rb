
require 'minitest/autorun'
require 'Bento'

require 'Confetti/lib/Test.rb'
require 'Activity'

#----------------------------------------------------------------------------------------------

class Primitives < Confetti::Test

	def create_vob?; true; end
	def create_fs?; true; end

	def before
		@@act = Confetti::Activity.create("myact1")
	end
	
	def test_new_act
		assert_equal "myact1", @@act.name
		assert_equal "myact1", @@act.branch.to_s
		assert_equal "myact1", @@act.view.to_s
	end	
	
	def test_existing_act
#		assert_equal 
	end	
end

#----------------------------------------------------------------------------------------------

if 0

#----------------------------------------------------------------------------------------------

class CreateFromProjectHead < Confetti::Test

	def create_vob?; true; end

	def before
	end
end

#----------------------------------------------------------------------------------------------

class CreateFromProjectVersion < Confetti::Test
end

#----------------------------------------------------------------------------------------------

class Check < Confetti::Test
end

#----------------------------------------------------------------------------------------------

class Build < Confetti::Test
end

#----------------------------------------------------------------------------------------------

end
