
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

class Branch
	include Bento::Class

	attr_reader :name, :tag

	def is(name, *opt)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid branch name" if name.to_s.empty?

		if !TEST_MODE
			@branch = ClearCASE.Branch(name, *opt1)
			@name = @branch.name

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@branch = ClearCASE.Branch(name, *opt1)
			@name = @branch.name
		else
			fix_name(name)
		end
	end

	def create(name, *opt, stream: nil)
		byebug
	
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid branch name" if name.to_s.empty?

		if !TEST_MODE
			@branch = ClearCASE::Branch.create(name, *opt1)
			@name = @branch.name

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@branch = ClearCASE.Branch(name, *opt1, root_vob: Test.root_vob)
			@name = @branch.name
		else
			fix_name(name)
		end

		# we should implement lazy branch creation, as we cannot create a branch without knowing
		# its associated project, and specifying a project here would be inappropriate.

		# raise "invalid stream specification" if !stream
	end

	def fix_name(name)
		@name = name.to_s
		@name = System.user.downcase + "_" + @name if !@raw
	end

	#-------------------------------------------------------------------------------------------

	def to_s; name; end
	def to_str; name; end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

	private :is, :create
	private_class_method :new

end # class Stream

def self.Branch(*args)
	x = Branch.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
