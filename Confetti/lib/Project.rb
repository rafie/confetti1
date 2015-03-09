
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
	
	constructors :is, :from_id, :from_row, :create, :create_from_project
	## later: :create_from_version
	
	members :row, :id, :name, :branch, :ctl_view, :config

	# opt:
	# :verify - verify project existence
	def is(name, *opt)
		init_flags([:verify], opt)

		from_row(db.one("select * from projects where name=?", name))
	end

	def from_row(db_row)
		@row = db_row

		@id = row[:id]
		@name = row[:name]

		@branch = Confetti.Branch(row[:branch])

		# what for? can this be removed?
		# @cspec = Confetti.CSpec(row[:cspec]) if !row[:cspec].empty?

		@ctl_view = Confetti.ProjectControlView(self)

		@config = Confetti::ProjectConfig.from_path(config_path)

		assert_good
	end

	def from_id(id)
		@id = id
		from_row(db.one("select * from projects where id=?", id))
	end

	def create(name, *opt, branch: nil, baseline_cspec: nil, lspec: nil)
		raise "invalid project name" if name.to_s.strip.empty?

		@name = name.to_s
		raise "Project #{name} exists." if exist?

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@config = ProjectConfig.create(@name, branch: branch, baseline_cspec: baseline_cspec, lspec: lspec)

		create_control_view
		create_config_files
		create_db_record # should use transaction here

		assert_good

		# 	rescue Exception => x
			# should rollback ctl_view and db work
		#		raise "failed to create project #{name}: " + x.to_s
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
	def create_from_version(name, *opt, branch: nil, from_project: nil, from_version: nil)
		raise "invalid project name" if name.to_s.strip.empty?
		@name = name

		raise "Project #{name} exists." if exist?

		raise "invalid source project version specification" if !from_version

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@config = ProjectConfig.create_from_config(@name, branch: branch, config: from_version.project.config)

		create_control_view
		create_config_files
		create_db_record # should use transaction here

		assert_good

		rescue Exception => x
			rollback
			raise "failed to create project #{name}: " + x.to_s
	end

	#------------------------------------------------------------------------------------------
	# construction
	#------------------------------------------------------------------------------------------

	def exist?
		!!db.single("select * from projects where name=?", @name)
	end

	def create_db_record
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

	def rollback
	end

	def assert_good
		return if \
			   @id \
			&& @name \
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

	def id
		@id = db.val("select id from projects where name=?", @name) if !@id
		@id
	end

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

	def cspec
		config.baseline
	end

	alias_method :baseline, :cspec
	
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

	# opt: :keepco
	def check!(*opt)
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

#	private :config_nexp, :row, :assert_ready
	private :rollback

end # Project

#----------------------------------------------------------------------------------------------

class CurrentProject < Project

	constructors :is

	def is
		raise "unimplemented"
	end

end # CurrentProject

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
		@rows.each { |row| yield Project.from_row(row) }
	end

	def db
		Confetti::DB.global
	end

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
