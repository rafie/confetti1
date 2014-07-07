require 'minitest/autorun'
require '../lib/Project.rb'

module Confetti

CONFETTI_TEST = 1

end

class Projects1 < Minitest::Test

	def setup
#		byebug
		@projects = Confetti::All::Projects.new
		p = @projects.first
		puts p.name
		a = 1
	end

	def test_all_projects
		names = @projects.map { |project| project.name }
		assert_equal %w(main ucgw-7.7 ucgw-8.0 mcu-7.7 mcu-8.0 test).sort, names.sort
	end
end
