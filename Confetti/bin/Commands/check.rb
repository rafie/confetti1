
require 'commander/import'
require 'Confetti'

module Confetti
module Commands

class Check
	def Check.command(c)
		c.syntax = 'tt check [options] [activity-name]'
		c.summary = 'Check an activity'
		c.description = c.summary

		c.example 'Check current activity', 'tt check'
		c.example 'Check activity ACT', 'tt check --name ACT'
		c.example 'Check current activity, but only lot LOT', 'tt check --lot LOT'

		c.option '--name NAME', 'Name of activity'
		c.option '--lot NAME', 'Check lot (repeatable)'
		c.option '--keepco', 'Re-check-out elements after labeling'

		c.action Check
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
				raise "Cannot determine activity. Please specify activity name."
			end
		end

		flags << :keepco if options.keepco

		say "Checking activity #{act_name} ..."
		
		act = Confetti.Activity(act_name)
		check = act.check!(*flags)

		say "Activity #{act_name} checked with #{check}."
		say "Checkouts are preserved." if keepco
	end
end

end # Commands
end # Confetti
