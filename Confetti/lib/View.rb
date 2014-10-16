require_relative 'Common'
require_relative 'Branch'

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

class View
	include Bento::Class

	constructors :is, :create
	members :id, :raw, :name, :view

	attr_reader :name

	def is(name, *opt)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid name" if !name
		@name = name.to_s

		row = db.one("select id, name, user, cspec from views where name=?", @name)
		fail "Unknown view: #{@name}" if row == nil
		from_row(row)

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

	def create(name, *opt, cspec: nil)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)
		
		raise "invalid cspec" if !cspec

		if !TEST_MODE
			@view = ClearCASE::View.create(name, *opt1)

		elsif TEST_WITH_CLEARCASE
			raise "no active test" if !Test.current
			@view = ClearCASE::View.create(name, *opt1, root_vob: Test.root_vob)

		else
			@view = Confetti::TestView.create(name, *opt1)
		end

		@name = @view.name

		@id = db.insert(:views, %w(name user cspec), @name, @user, @cspec)
	end

	def from_row(row)
		@id = row[:id]
		@user = User.new(row[:user])
		@name = row[:name] if !@name
		@cspec = Confetti.CSpec(row[:cspec])
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

	def checkin(glob)
		@view.checkin(glob)
	end

	def checkout(glob)
		@view.checkout(glob)
	end

	def add_files(glob)
		@view.add_files(glob)
	end

	#-------------------------------------------------------------------------------------------

	def db
		Confetti::DB.global
	end
end

#----------------------------------------------------------------------------------------------

class CurrentView < View

	constructors :is
	members :view

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
end # CurrentView

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
end

#----------------------------------------------------------------------------------------------

end # module Confetti
