
require 'minitest/autorun'
require '../lib/Project.rb'
require '../lib/Test.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class AllProjects < Confetti::Test

	def create_vob?; false; end

	def before
		@@all_projects_names = %w(ucgw-7.7 mcu-8.0 mcu-8.3).sort
		@@projects = Confetti::All::Projects.new
	end

	def test_all_projects
		names = @@projects.map { |project| project.name }
		assert_equal @@all_projects_names, names.sort
	end

end

#----------------------------------------------------------------------------------------------

class CreateFromSpecFiles < Confetti::Test

	def create_vob?; true; end

	def before
		@@project = Confetti::Project.create('test1', 
			baseline_cspec: Confetti::CSpec.from_file('project1-test2.cspec'),
			lspec: Confetti::LSpec.from_file('project1-test2.lspec'))
	end

#	def after
#		@@project = nil
#	end

	def after_cleanup
		Confetti::Project('test1').ctl_view.remove!
	end

	def test_name
		assert_equal 'test1', @@project.name
		assert_equal 'test1_int_br', @@project.branch.name
	end

	def test_record_exist_in_db
		assert_equal true, @@project.exist?
	end

	def test_control_view
		assert_equal true, Dir.exists?(@@project.ctl_view.root)
	end

	def test_project_config
		project = @@project
		assert_equal project.name, project.nexp[:project].car.to_s
#		assert_equal ~project.cspec.nexp, ~project.nexp[:baseline]
		assert_equal 0, project.nexp[:itag].to_i
		assert_equal 0, project.nexp[:icheck].to_i
		assert_equal %w(nbu.mcu nbu.web nbu.media nbu.dsp nbu.infra nbu.bsp nbu.contrib nbu.build nbu.tests).sort,
			(~project.nexp[:lots]).sort
	end

	def test_lspec
		byebug
		assert_equal ~Confetti::LSpec.from_file('project1-test2.lspec').nexp, ~@@project.lspec.nexp
	end

end

#----------------------------------------------------------------------------------------------

class CreateFromProject < Confetti::Test

	def create_vob?; true; end

	def before
		@@project = Confetti::Project.create_from_project('test1', from_project: Confetti.Project('mcu-8.3'))
		# also possible: @@project = Confetti::Project.create('test1', from_project: 'mcu-8.3')
	end

	def after_cleanup
		Confetti::Project('test1').ctl_view.remove!
	end

	def test_name
		assert_equal 'test1', @@project.name
		assert_equal 'test1_int_br', @@project.branch.name
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
		assert_equal ~Confetti.Project('mcu-8.3').lspec.nexp, ~@@project.lspec.nexp
	end

end

#----------------------------------------------------------------------------------------------

if Confetti::TEST_WITH_CLEARCASE && false

#----------------------------------------------------------------------------------------------

class Test3 < Confetti::Test

	def create_vob?; true; end

#	def keep?; true; end

	@@cspec = <<END
(cspec
	:tag nbu.mcu-8.3.1.3.5
	:stem nbu.mcu-8.3
	(lots
		nbu.mcu
		(nbu.web     WebMcu_8.3_1_SP1_1_240314.5628)
		(nbu.media   nbu.media_8.3.1.3.2)
		(nbu.dsp     nbu.dsp_8.3.1.3.5.0)
		(nbu.bsp     nbu.bsp_1.0.0.7.9)
		(nbu.infra   nbu.infra_mcu-8.0_3.0)
		(nbu.contrib nbu.contrib_mcu-8.3.1.3.0)
		(nbu.tests   nbu.tests_1.7.3)
		(nbu.build   nbu.build_1.4.19)
	)
	(checks 16 17 18))
END

@@project_config = <<END
END

	def after_cleanup
		Confetti::Project('test1').ctl_view.remove! rescue ''
		Confetti::Project('test2').ctl_view.remove! rescue ''
	end

	def t(x)
		x.gsub(/[\t \n]+/," ")
	end

	def _test_project(project, name)
		assert_equal name, project.name
		assert_equal name + '_int_br', project.branch
		assert_equal t(@@cspec.strip), t(project.cspec.to_s)
		# assert_equal @@project_config, File.read(project.local_db_file)
	end

	def test_create1
		project = Confetti::Project.create('test1', baseline_cspec: @@cspec)
		_test_project(project, 'test1')
	end

	def test_create2
		Confetti::Project.create('test2', baseline_cspec: @@cspec)
		_test_project(Confetti.Project('test2'), 'test2')
	end
end

#----------------------------------------------------------------------------------------------

end # if Confetti::TEST_WITH_CLEARCASE

#----------------------------------------------------------------------------------------------
