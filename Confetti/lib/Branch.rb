
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

# In non-ClearCase environments (e.g., Git, Zeta), a branch is associated with a specific 
# repository (that is, no global branches). Therefore, branches should probably be associated
# with streams.

class Branch
	include Bento::Class

	constructors :is, :create
	members :raw, :name, :branch

	attr_reader :name, :tag

	def is(name, *opt)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid branch name" if name.to_s.empty?

		@branch = ClearCASE.Branch(name, *opt1)
		@name = @branch.name
	end

	def create(name, *opt, stream: nil)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid branch name" if name.to_s.empty?

		if Config.root_vob
			@branch = ClearCASE::Branch.create(name, *opt1, root_vob: Config.root_vob)
		else
			@branch = ClearCASE::Branch.create(name, *opt1)
		end
		@name = @branch.name

		# we should implement lazy branch creation, as we cannot create a branch without knowing
		# its associated project, and specifying a project here would be inappropriate.
	end

	def fix_name(name)
		@name = name.to_s
		@name = System.user.downcase + "_" + @name if !@raw
	end

	#-------------------------------------------------------------------------------------------

	def to_s; name; end
	def to_str; name; end

end # class Branch

#----------------------------------------------------------------------------------------------

end # module Confetti
