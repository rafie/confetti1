
require 'minitest/autorun'
require '../lib/Project.rb'
require '../lib/Test.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class CreateFromSpecFiles < Confetti::Test

	def create_vob?; true; end

	def before
		@@project = Confetti::Project.create("test1", 
			baseline_cspec: Confetti::CSpec.from_file("project1-test2.cspec"),
			lspec: Confetti::LSpec.from_file("project1-test2.lspec"))
	end

	def after_cleanup
		Confetti::Project('test1').ctl_view.remove!
	end

	def test_name
		assert_equal "test1", @@project.name
		assert_equal "test1_int", @@project.branch.name
	end

	def test_record_exist_in_db
		assert_equal true, @@project.exist?
	end

	def test_control_view
		assert_equal true, Dir.exists?(@@project.ctl_view.root)
	end

	def test_project_config
		project = @@project
		assert_equal project.name, project.config.project_name
#		assert_equal ~project.cspec.nexp, ~project.nexp[:baseline]
		assert_equal 0, project.config.itag
		assert_equal 0, project.config.icheck
		assert_equal %w(nbu.mcu nbu.web nbu.media nbu.dsp nbu.infra nbu.bsp nbu.contrib nbu.build nbu.tests).sort,
			project.config.lots.sort
	end

	def test_lspec
		assert_equal ~Confetti::LSpec.from_file("project1-test2.lspec").nexp, ~@@project.config.lspec.nexp
	end

end

#----------------------------------------------------------------------------------------------

class CreateFromProject < Confetti::Test

	def create_vob?; true; end

	def before
		@@project = Confetti::Project.create_from_project("test1", from_project: Confetti.Project("mcu-8.3"))
		# also possible: @@project = Confetti::Project.create("test1", from_project: "mcu-8.3")
	end

	def after_cleanup
		Confetti::Project("test1").ctl_view.remove!
	end

	def test_name
		assert_equal "test1", @@project.name
		assert_equal "test1_int", @@project.branch.name
	end

	def test_record_exist_in_db
		assert_equal true, @@project.exist?
	end

	def test_control_view
		assert_equal true, Dir.exists?(@@project.ctl_view.root)
	end

	def test_project_config
		project = @@project
		byebug
		assert_equal project.name, project.config_nexp[:project].car.to_s
		assert_equal ~project.cspec.nexp, ~project.nexp[:baseline]
		assert_equal 0, project.nexp[:itag].to_i
		assert_equal 0, project.nexp[:icheck].to_i
		assert_equal %w(nbu.prod.mcu nbu.mcu nbu.web nbu.media nbu.dsp nbu.infra nbu.bsp nbu.contrib nbu.build nbu.tests).sort,
			(~project.nexp[:lots]).sort
	end

	def test_lspec
		assert_equal ~Confetti.Project("mcu-8.3").lspec.nexp, ~@@project.lspec.nexp
	end

end

#----------------------------------------------------------------------------------------------

if false

#----------------------------------------------------------------------------------------------

class CreateFromVersion < Confetti::Test
end # class CreateFromVersion

#----------------------------------------------------------------------------------------------

class ProjectCheck < Confetti::Test
end # ProjectCheck

#----------------------------------------------------------------------------------------------

end # if false

#----------------------------------------------------------------------------------------------
