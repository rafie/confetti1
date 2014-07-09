require 'minitest/autorun'
require '../lib/Project.rb'

module Confetti

CONFETTI_TEST = 1

end

#----------------------------------------------------------------------------------------------

class Projects1 < Minitest::Test

	def setup
		@all_projects_names = %w(main ucgw-7.7 ucgw-8.0 mcu-7.7 mcu-8.0 test).sort

		@projects = Confetti::All::Projects.new

		p = @projects.first
		puts p.name
		a = 1
	end

	def test_all_projects
		names = @projects.map { |project| project.name }
		assert_equal @all_projects_names, names.sort
	end

end

#----------------------------------------------------------------------------------------------

class Projects2 < Minitest::Test

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

	def setup
	end

	def teardown
	end

	def test_create
		byebug
		Confetti::All::Projects.create('test1', cspec: @@cspec)
		project = Confetti::Project('test1')
		assert_equal 'test1', project.name
		assert_equal 'test1_int_br', project.name
		assert_equal '', project.root_vob
		assert_equal @@cspec, project.cspec
	end
end

#----------------------------------------------------------------------------------------------
