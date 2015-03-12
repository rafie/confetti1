
require_relative 'View'

module Confetti

#----------------------------------------------------------------------------------------------

# this may end up being a git-only view holding project metadata

class ProjectControlView < View
	include Bento::Class

	constructors :is, :create
	members :project_name, :branch

	attr_reader :project_name

	@@configspec_t = <<-END
element * CHECKEDOUT
element * .../<%= branch_name %>/LATEST
mkbranch <%= branch_name %>
element /<%= @view.root_vob %>/nbu.meta/... /main/0
element * /main/LATEST
end mkbranch
END

	# opt: :ready - make view available

	def is(project, *opt)
		raise "invalid project specification" if !project

		@project_name = project.name
		@branch = project.branch

		opt1 = filter_flags([:ready], opt)

		opt1 << :raw if !Confetti::Config.is_in_testenv?
		super(view_name, *opt1)
	end

	def create(project, *opt)
		raise "invalid project specification" if !project

		@project_name = project.name
		@branch = project.branch

		opt1 = []
		opt1 << :raw if !Confetti::Config.is_in_testenv?
		super(view_name, *opt1, cspec: project.config.cspec)

		if CONFETTI_CLEARCASE
			@configspec = Bento.mold(@@configspec_t, binding)
			@view.configspec = @configspec
		end
	end

	#-------------------------------------------------------------------------------------------

	def name
		@view.name
	end

	def view_name
		(Confetti::Config.is_in_testenv? ? "confetti" : "") + '.project_' + project_name
	end

	def branch_name
		@branch.name
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
