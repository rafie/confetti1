
require 'minitest/autorun'
require '../lib/Project.rb'
require '../lib/Test.rb'
require 'byebug'

#----------------------------------------------------------------------------------------------

class Projects1 < Confetti::Test

#	def keep?; true; end


	def setup
#		puts 'Projects1: ' + @path
#		puts 'Projects1 DB: ' + Confetti::Config.db_path

		@all_projects_names = %w(main ucgw-7.7 ucgw-8.0 mcu-7.7 mcu-8.0 test).sort

		@projects = Confetti::All::Projects.new
	end

	def test_all_projects
		names = @projects.map { |project| project.name }
		assert_equal @all_projects_names, names.sort
	end

end

#----------------------------------------------------------------------------------------------

class Projects2 < Confetti::Test

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
	(checks 16 17 18)
)
END

@@project_ne = <<END
END

	def setup
#		puts 'Projects2: ' + @path
	end

	def _test_project(project, name)
		assert_equal name, project.name
		assert_equal name + '_int_br', project.branch
		assert_equal '', project.root_vob
		byebug
		assert_equal @@cspec, project.cspec.to_s
#		assert_equal @@project_ne, File.read(@project.local_db_file)
	end

	def test_create1
		project = Confetti::Project.create('test1', cspec: @@cspec)
		_test_project(project, 'test1')
	end

	def test_create2
		Confetti::Project.create('test2', cspec: @@cspec)
		_test_project(Confetti::Project.new('test2'), 'test2')
	end
end

#----------------------------------------------------------------------------------------------
