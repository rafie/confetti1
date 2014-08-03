
require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

class Branch

	attr_reader :name

	def is(name, *opt)
		raise "invalid branch name" if name.to_s.strip.empty?
		@name = name.to_s
	end

	def create(name, *opt, stream: nil)
		# we should implement lazy branch creation, as we cannot create a branch without knowing
		# its associated project, and specifying a project here would be inappropriate.

		raise "unimplemented"
		raise "invalid branch name" if name.to_s.strip.empty?

		raise "invalid stream specification" if !stream
		@name = name.to_s
	end

	#-------------------------------------------------------------------------------------------

	def to_s; name; end
	def to_str; name; end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	private :is, :create
	private_class_method :new

end # class Stream

def self.Branch(*args)
	x = Branch.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
