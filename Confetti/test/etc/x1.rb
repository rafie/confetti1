require 'erb'

require_relative '../lib/Confetti'
require_relative '../lib/Lot'
# require_relative 'CSpec'
# require_relative 'View'

module Confetti

class Project

	@@ne_template = <<-END
(project <%= @name %>
	(baseline <%= cspec.to_s %>)
	:itag 0
	:icheck 0
	(lots 
		<% for lot in lots %> <%= lot.name %><% end %>))
END

	def cspec
		"myproj"
	end

	def lots
		Lots.new(['nbu.mcu', 'nbu.dsp'])
#		['nbu.mcu', 'nbu.dsp']
	end

	def foo
#		@lots = ['nbu.mcu', 'nbu.dsp']
		ERB.new(@@ne_template, 0, "-").result(binding)
	end

end

end # module Confetti

puts Confetti::Project.new.foo
