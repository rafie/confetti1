require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class TestView
	include Bento::Class

	attr_reader :name

	def initialize(name, *opt)
		return if tagged_init(:create, opt, [name, *opt])
		@name = name
	end

	def TestView.create(name, *opt)
		TestView.new(name, :create)
	end

	def path
		Config.view_path(@name)
	end

	private

	def create(name, *opt, root_vob: nil)
		FileUtils.mkdir_p(Config.view_path(name))
		@name = name
		self
	end
end

#----------------------------------------------------------------------------------------------

class View
	include Bento::Class

	attr_reader :name

	def initialize(name, *opt, root_vob: nil)
		return if tagged_init(:create, opt, [name, *opt, root_vob: root_vob])

		@name = name
		if !TEST_MODE
			@view = ClearCASE::View.new(name, root_vob: root_vob)
		else
			@view = TestView.new(name)
		end
	end

	def View.create(name, *opt, root_vob: nil)
		View.new(name, :create, root_vob: root_vob)
	end

	def path
		@view.path
	end

	private

	def create(name, *opt, root_vob: nil)
		@name = name
		if !TEST_MODE
			@view = ClearCASE::View.create(name, root_vob: root_vob)
		else
			@view  = TestView.create(name)
		end
	end
end

#----------------------------------------------------------------------------------------------

class ProjectControlView < View

	@@configspec_t = ERB.new <<-END
element * CHECKEDOUT
element * .../<%= branch_name %>/LATEST
mkbranch <%= branch_name %>
element /nbu.meta/... /main/0
element * /main/0
end mkbranch
END

	def initialize(*opt, project_name: nil, branch: nil, root_vob: nil)
		raise "invalid project name" if !project_name
		raise "invalid branch" if !branch

		return if tagged_init(:create, opt, [*opt, project_name: project_name, branch: branch, root_vob: root_vob])

		@project_name = project_name
		view_name = '.project_' + project_name
		@branch = branch

		super(view_name, *opt, root_vob: root_vob)
	end

	def View.create(*opt, project_name: nil, branch: nil, root_vob: nil)
		ProjectControlView.new(*opt << :create, project_name: project_name, branch: branch, root_vob: root_vob)
	end

	def branch_name
		@branch
	end

	private

	def create(*opt, project_name: nil, branch: nil, root_vob: nil)
		raise "invalid branch" if !branch

		@project_name = project_name
		view_name = '.project_' + project_name
		@branch = branch
		super(view_name, *opt, root_vob: root_vob)

		if !TEST_MODE # ugly hack
			configspec = @@configspec_t.result(binding)
			@view.configspec = @configspec
		end
	end

end

#----------------------------------------------------------------------------------------------

end # module Confetti
