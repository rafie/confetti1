
require 'minitest/autorun'

# require 'Common'
require 'Confetti/lib/Test'
require 'Activity'
require 'Project'

#----------------------------------------------------------------------------------------------

class Primitives < Confetti::Test

	def create_vob?; true; end
	def create_fs?; true; end

	def before
		@@act = Confetti::Activity.create("myact1", project: Confetti::Project('mcu-8.0'))
		@@user = System.user.downcase + "_"
	end
	
	def test_new_act
		assert_equal @@user + "myact1", @@act.name
		assert_equal @@user + "myact1", @@act.branch.name
		assert_equal @@user + "myact1", @@act.view.name
	end	
	
	def test_existing_act
		@act1 = Confetti.Activity(@@user + "myact1")
		assert_equal @@user + "myact1", @@act.name
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
