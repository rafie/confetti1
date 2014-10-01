
require_relative 'Confetti'
require_relative 'Stream'
require_relative 'CSpec'
require_relative 'LSpec'
require_relative 'ProjectConfig'
require_relative 'View'
require_relative 'Lot'

module Confetti

#----------------------------------------------------------------------------------------------

class Project < Stream
	include Bento::Class

	attr_reader :id, :name, :branch, :config

	#------------------------------------------------------------------------------------------
	# constructors
	#------------------------------------------------------------------------------------------
	
	# constructors :is, :create

	# opt:
	# :verify - verify project existence

	def is(name, *opt, db_row: nil)
		init_flags([:verify], opt)

		@name = name
		@row = db_row if !!db_row

		@branch = Confetti.Branch(row[:branch])

		# what for? can this be removed?
		# @cspec = Confetti.CSpec(row[:cspec]) if !row[:cspec].empty?

		@ctl_view = Confetti.ProjectControlView(self)

		@config = Confetti::ProjectConfig.from_path(config_path)

		assert_good
	end

	def create(name, *opt, branch: nil, baseline_cspec: nil, lspec: nil)
		raise "invalid project name" if name.to_s.strip.empty?

		@name = name
		raise "Project #{name} exists." if exist?

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@config = ProjectConfig.create(@name, branch: branch, baseline_cspec: baseline_cspec, lspec: lspec)

		create_control_view
		create_config_files
		create_db_record # should use transaction here

		assert_good

#		rescue Exception => x
			# should rollback ctl_view and db work
#			raise "failed to create project #{name}: " + x.to_s
	end

	def create_from_project(name, *opt, branch: nil, from_project: nil)
		raise "invalid project name" if name.to_s.strip.empty?
		@name = name

		raise "Project #{name} exists." if exist?

		raise "invalid source project specification" if !from_project

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@config = ProjectConfig.create_from_config(@name, branch: branch, config: from_project.config)

		create_control_view
		create_config_files
		create_db_record # should use transaction here

		assert_good

		rescue Exception => x
			rollback
			raise "failed to create project #{name}: " + x.to_s
	end

	def rollback
	end

	#------------------------------------------------------------------------------------------
	# construction
	#------------------------------------------------------------------------------------------

	def exist?
		!!db.single("select * from projects where name=?", [@name])
	end

	def create_db_record
#		db.insert('projects', %w(name branch cspec), [@name, @branch.name, @cspec.to_s])
#		db.execute("insert into projects (name, branch, cspec) values (?, ?, ?)",
#			[@name, @branch.name, @cspec.to_s])
		@id = db.insert(:projects, %w(name branch cspec), @name, @branch.name, @cspec.to_s)
	end

	def create_control_view
		@ctl_view = ProjectControlView.create(self)
	end

	def create_config_files
		FileUtils.mkdir_p(config_path)
		@config.write(config_path)
		@config.add_to_view(@ctl_view)
	end

	def assert_good
		return if \
			   @name \
			&& row \
			&& @branch \
			&& @ctl_view \
			&& @config
		byebug
		raise "Project no good"
	end

	#------------------------------------------------------------------------------------------
	# configuration
	#------------------------------------------------------------------------------------------

	def std_branch_name
		@name + "_int"
	end

	def ctl_view
		return @ctl_view if @ctl_view
		@ctl_view = Confetti.ProjectControlView(self, :ready)
	end

	def config_path
		Config.path_in_view(ctl_view)
	end

	def row
		@row = db.single("select * from projects where name=?", @name) if !@row
		@row
	end

	def db
		Confetti::DB.global
	end
	
	#------------------------------------------------------------------------------------------
	# operations
	#------------------------------------------------------------------------------------------

	def new_activity(name, project, version: nil)
	end

	def lots
		Lots.new(~config_nexp[:lots])
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
		x = self.send(:new); x.send(:create_from_project, *args); x
	end

#	private :config_nexp, :row, :assert_ready
	private :rollback

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
	end

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
