
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class Mark
	def Mark.command(c)
		c.syntax = 'tt mark [options] [activity-name]'
		c.summary = 'Mark state of an activity'
		c.description = c.summary

		c.example 'Mark state of current activity', 'tt mark'
		c.example 'Mark state of activity ACT', 'tt mark --name ACT'
		c.example 'Mark state of current activity, but only lot LOT', 'tt mark --lot LOT'

		c.option '--name NAME', 'Name of activity'
		c.option '--lot NAME', 'Mark specific lot (repeatable)'
		c.option '--keepco', 'Re-check-out elements after labeling'

		c.action Mark
	end

	def initialize(args, options)
		flags = []

		act_name = args.shift
		act_name = options.name if !act_name && !!options.name
		if !act_name
			begin
				act = Confetti.CurrentActivity
				act_name = act.anme
			rescue
				raise "Cannot determine activity. Please specify activity name"
			end
		end

		flags << :keepco if options.keepco

		say "Marking activity #{act_name} ..."
		
		act = Confetti.Activity(act_name)
		mark = act.mark!(nil, flags)
		
		say "Activity #{act_name} marked with #{mark}."
		say "Checkouts are presersed." if keepco
	end
end

end # Commands
end # Confetti
