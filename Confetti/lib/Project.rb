
require_relative 'Confetti'
require_relative 'Stream'
require_relative 'CSpec'
require_relative 'LSpec'
require_relative 'View'
require_relative 'Lot'

module Confetti

#----------------------------------------------------------------------------------------------

# (project project-name
# 	(baseline
#		cspec)
# 
# 	:icheck N
# 	:itag N
# 	
# 	(lots
# 		lot-names ...)
# 	
# 	(products
# 		(product product-name :lot product-lot))
# )

class Project < Stream
	include Bento::Class

	attr_reader :name, :branch
	attr_accessor :cspec

	#------------------------------------------------------------------------------------------
	# constructors
	#------------------------------------------------------------------------------------------

	# opt:
	# :verify - verify project existsance

	def is(name, *opt, db_row: nil)
		init_flags([:verify], opt)

		@name = name
		@row = db_row if !!db_row

		@branch = row[:branch]
		@cspec = row[:cspec]

		@ctl_view = Confetti.ProjectControlView(project_name: @name)

		assert_ready
	end

	def create(name, *opt, branch: nil, cspec: nil, lspec: nil)
		raise "invalid project name" if name.to_s.strip == ''

		@name = name
		raise "Project #{name} exists." if exist?

		@branch = std_branch_name if !branch
		@cspec = Confetti.CSpec(cspec) if cspec
		@lspec = Confetti.LSpec(lspec) if lspec

		create_db_record
		create_control_view
		create_config_files

		assert_ready

#		rescue Exception => x
#			raise "failed to create project #{name}: " + x.to_s
	end

	def create_from_project(name, *opt, branch: nil, from_project: nil)
		raise "unimplemented"

		assert_ready

		rescue Exception => x
			raise "failed to create project #{name}: " + x.to_s
	end

	#------------------------------------------------------------------------------------------
	# construction
	#------------------------------------------------------------------------------------------

	def exist?
		!!Confetti::DB.global.single("select * from projects where name=?", [@name])
	end

	def create_db_record
		Confetti::DB.global.execute("insert into projects (name, branch, cspec) values (?, ?, ?)",
			[@name, @branch, @cspec.to_s])
	end

	def create_control_view
		@ctl_view = ProjectControlView.create(project_name: @name, branch: @branch)
	end

	@@ne_template = <<-END
(project <%= @name %>
	(baseline 
		<%= cspec.to_s %>)
	:itag 0
	:icheck 0
	(lots 
		<%for lot in @lots %> <%= lot %> <% end %>))
END

	def create_config_files
		@lots = @lspec.lots.keys
		project_ne = Bento.mold(@@ne_template, binding)
		project_ne_path = config_file('project.ne')
		File.write(project_ne_path, project_ne)
		@ctl_view.add_file(project_ne_path)

		lspec_path = config_file('lots.ne')
		File.write(lspec_path, @lspec)
		@ctl_view.add_file(lspec_path)
	end

	def assert_ready
#		byebug
#		raise "not ready" if !@name || !@row || !@branch || !@ctl_view || !@cspec
	end

	#------------------------------------------------------------------------------------------
	# configuration
	#------------------------------------------------------------------------------------------

	def std_branch_name
		@name + "_int_br"
	end

	def lspec_file
	end

	def ctl_view
		return @ctl_view if @ctl_view
		@ctl_view = Confetti.ProjectControlView(name, :ready)
	end

	def config_path
		Config.view_path(ctl_view.name)
	end

	def config_file(file)
		config_path + "/" + file
	end

	def nexp
		return @project_ne if @project_ne
		@project_ne = Nexp::Nexp.from_file(config_file('project.ne'), :single)
	end

	def lotspec
		Confetti::LSpec.from_file(config_file('lots.ne'))
	end

	def row
		@row = Confetti::DB.global.single("select * from projects where name=?", [@name]) if !@row
		@row
	end

#	def cspec
#		@cspec.to_s
#	end

#	def cspec=(text)
#		@cspec = Confetti.CSpec(text)
#	end

	#------------------------------------------------------------------------------------------
	# operations
	#------------------------------------------------------------------------------------------

	def new_activity(name, project, version: nil)
	end

	def lots
		Lots.new(~nexp[:lots])
	end

	def check!
	end

	def new_version!
	end

	def tag!
	end

	#------------------------------------------------------------------------------------------

	def self.current
		CurrentProject.new
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

	def self.create_from_project(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

#	private :nexp, :row, :assert_ready

	private :is, :create, :create_from_project
	private_class_method :new
end # Project

def self.Project(*args)
	x = Project.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class CurrentProject < Project

	def is
		raise "unimplemented"
	end

	private :is
	private_class_method :new

end # CurrentProject

def self.CurrentProject(*args)
	x = CurrentProject.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class Projects
	include Enumerable

	def initialize(names)
		@names = names
	end

	def self.all
		raise "unimplemented"
	end

	def each
		@names.each { |name| yield Confetti.Proejct(name) }
	end
end # Projects

#----------------------------------------------------------------------------------------------

module All

#----------------------------------------------------------------------------------------------

class Projects

	include Enumerable

	def initialize
		@rows = db["select * from projects"]
		fail "Cannot determine all projets" if @rows == nil
	end

	def each
		@rows.each { |row| yield Confetti.Project(row[:name], db_row: row) }
	end

	def db
		Confetti::DB.global
#		Nexp::Nexp.from_file(Confetti::Config.view_path + "/projects.ne", :single)
	end

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
