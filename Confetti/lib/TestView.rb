module Confetti

#----------------------------------------------------------------------------------------------

class TestView
	include Bento::Class

	constructors :is, :create
	members :name, :raw

	attr_reader :name

	def is(name, *opt)
		init_flags([:raw], opt)

		if name.to_s.empty?
			@name =  ".current"
		else
			@name = name.to_s
			@name = System.user.downcase + "_" + @name if !@raw
		end
	end

	def create(name, *opt)
		init_flags([:raw], opt)
		
		@name = name.to_s
		@name = System.user.downcase + "_" + @name if !@raw
		
		FileUtils.mkdir_p(path)
	end

	#-------------------------------------------------------------------------------------------

	def path
		Test.root + "/views/" + @name
	end

	def root
		path
	end

	def remove!
		# do nothing
	end

	def checkin(glob)
		# no nothing
	end

	def checkout(glob)
		# no nothing
	end

	def add_files(glob)
		# no nothing
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
