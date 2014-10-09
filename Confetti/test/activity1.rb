
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

class CreateFromProjectHead < Confetti::Test

	def create_vob?; true; end

	def before
		@@act = Confetti::Activity.create("myact1", project: Confetti::Project('mcu-8.0'))
	end
end

#----------------------------------------------------------------------------------------------

class Check < Confetti::Test
	def create_vob?; true; end

	def before
		@@project = Confetti::Project('mcu-8.0')
		@@act = Confetti::Activity.create("myact1", project: @@project)
		view1 = @@act.view
		@@root1 = view1.root
		FileUtils.copy_file(root1 + "/rvfc/makefile", root1 + "/rvfc/makefile1")
		view.add_files(root1 + "/rvfc/makefile1")
		check = @@act.check
	end

	def test_check
		view2 = Confetti.View.create("view2", cspec: @@act.cspec)
		assert_equal File.read(@@act.view.root + "/rvfc/makefile1"), File.read(@@view2.root + "/rvfc/makefile1") 
	end
end

#----------------------------------------------------------------------------------------------

if 0

#----------------------------------------------------------------------------------------------

class CreateFromProjectVersion < Confetti::Test
end

#----------------------------------------------------------------------------------------------

class Build < Confetti::Test
end

#----------------------------------------------------------------------------------------------

end
