require_relative 'Common'
require_relative 'Branch'

module Confetti

#----------------------------------------------------------------------------------------------

class TestView
	include Bento::Class

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

	def add_files(glob)
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
		opt1 = filter_flags([:raw], opt)

		@name = name

		if !TEST_MODE
			@view = ClearCASE.View(name)

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@view = ClearCASE.View(name, *opt1, root_vob: Test.root_vob)

		else
			opt1 = filter_flags([:raw], opt)
			@view = Confetti.TestView(name, *opt1)
		end
		
		@name = @view.name
	end

	def create(name, *opt)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		if !TEST_MODE
			@view = ClearCASE::View.create(name, *opt1)

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@view = ClearCASE::View.create(name, *opt1, root_vob: Test.root_vob)

		else
			@view = Confetti::TestView.create(name, *opt1)
		end

		@name = @view.name
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

	def add_files(glob)
		@view.add_files(path)
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

	@@configspec_t = <<-END
element * CHECKEDOUT
element * .../<%= branch_name %>/LATEST
mkbranch <%= branch_name %>
element /<%= @view.root_vob %>/nbu.meta/... /main/0
element * /main/0
end mkbranch
END

	# opt: :ready - make view available

	def is(project, *opt)
		raise "invalid project specification" if !project

		@project_name = project.name
		@branch = project.branch

		opt1 = filter_flags([:ready], opt)

		opt1 << :raw if !(TEST_MODE && TEST_WITH_CLEARCASE)
		super(view_name, *opt1)
	end

	def create(project, *opt)
		raise "invalid project specification" if !project

		@project_name = project.name
		@branch = project.branch

		opt1 = []
		opt1 << :raw if !(TEST_MODE && TEST_WITH_CLEARCASE)
		super(view_name, *opt1)

		if !TEST_MODE || TEST_WITH_CLEARCASE
			@configspec = Bento.mold(@@configspec_t, binding)
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
			'confetti-project_' + project_name
		end
	end

	def branch_name
		@branch.name
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
