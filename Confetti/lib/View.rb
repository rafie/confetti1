require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class TestView
	include Bento::Class

	attr_reader :name

	def is(name, *opt)
		@name = name
	end

	def create(name, *opt)
		@name = name
		FileUtils.mkdir_p(path)
	end

	#-------------------------------------------------------------------------------------------

	def path
		Config.view_path(@name)
	end

	def root
		path
	end

	def remove!
		# do nothing
	end

	def add_file(path)
		# no nothing
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end
	
	protected :is, :create
	private_class_method :new
end

def self.TestView(*args)
	x = TestView.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class View
	include Bento::Class

	attr_reader :name

	def is(name, *opt)
		init_flags([:raw], opt)

		@name = name

		if !TEST_MODE
			@view = ClearCASE.View(name)

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			view_opt = filter_flags([:raw], opt)
			@view = ClearCASE.View(name, root_vob: Test.current.root_vob)

		else
			@view = Confetti.TestView(name)
		end
	end

	def create(name, *opt)
		init_flags([:raw], opt)

		@name = name

		if !TEST_MODE
			view_opt = filter_flags([:raw], opt)
			@view = ClearCASE::View.create(name, *view_opt)

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@view = ClearCASE::View.create(name, root_vob: Test.current.root_vob)

		else
			@view  = Confetti::TestView.create(name)
		end
	end

	#-------------------------------------------------------------------------------------------

	def path
		@view.path
	end

	def root
		@view.root
	end

	def remove!
		@view.remove!
	end

	#-------------------------------------------------------------------------------------------

	def add_file(path)
		if !TEST_MODE || TEST_WITH_CLEARCASE
			@view.add_file(path)
		else
			@view.add_file(path)
		end
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end
	
	protected :is, :create
	private_class_method :new
end

def self.View(*args)
	x = View.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class CurrentView < View

	def is(*opt)
		if !TEST_MODE
			@view = ClearCASE.CurrentView

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@view = ClearCASE.CurrentView(root_vob: Test.current.root_vob)

		else
			@view = Confetti.TestView(name)
		end
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	protected :is, :create
	private_class_method :new

end # CurrentView

def self.CurrentView(*args)
	x = CurrentView.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class ProjectControlView < View
	include Bento::Class

	attr_reader :project_name

	@@configspec_t = ERB.new <<-END
element * CHECKEDOUT
element * .../<%= branch_name %>/LATEST
mkbranch <%= branch_name %>
element /nbu.meta/... /main/0
element * /main/0
end mkbranch
END

	def is(*opt, project_name: nil, branch: nil)
		raise "invalid project name" if !project_name
		raise "invalid branch" if !branch

		@project_name = project_name
		@branch = branch

		super(view_name, *opt << :raw)
	end

	def create(*opt, project_name: nil, branch: nil)
		raise "invalid branch" if !branch

		@project_name = project_name
		@branch = branch
		super(view_name, *opt)

		if !TEST_MODE && TEST_WITH_CLEARCASE
			configspec = @@configspec_t.result(binding)
			@view.configspec = @configspec
		end
	end

	#-------------------------------------------------------------------------------------------

	def name
		@view.name
	end

	def view_name
		if !TEST_MODE || !TEST_WITH_CLEARCASE
			'.project_' + project_name
		else
			'_confetti-project_' + project_name
		end
	end

	def branch_name
		@branch
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end
	
	private :view_name

	protected :is, :create
	private_class_method :new
end

def self.ProjectControlView(*args)
	x = ProjectControlView.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

end # module Confetti
