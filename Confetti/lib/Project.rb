
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
# 	:stem stem
# 	:icheck N
# 	:itag N
#   :upstream stream
# 	
# 	(lots
# 		lot-names ...)
# 	
# 	(products
# 		(product product-name :lot product-lot))
# )

# :stem specifies prefix of checks
# :icheck specifies last check number applied (starts with 0)
# :itag specifies last tag applied (starts with 0)
# :upstream specifies the upstream (for rebase/deliver operations)

class ProjectConfig
	include Bento::Class

	def from_files(path)
		cspec_text = cspec.is_a? File ? cspec.read : cspec.to_s
		lspec_text = lspec.is_a? File ? lspec.read : lspec.to_s
	end

	def from_path(cspec, lspec)
	end

	def create(name, baseline_cspec: nil, lspec: nil, upstream: nil)
	end

	#-------------------------------------------------------------------------------------------

	def nexp

	end

	def lspec_nexp
	end

	#-------------------------------------------------------------------------------------------

	def project_name
		~nexp.cadr
	end

	def project_name=(name)
	end

	def stem
		nexp[:stem]
	end

	def icheck
		nexp[:icheck]
	end

	def inc_icheck
		nexp[:icheck] = nexp[:icheck].to_i + 1
	end

	def itag
		nexp[:itag]
	end

	def inc_itag
		nexp[:itag] = nexp[:itag].to_i + 1
	end

	def upstream
		nexp[:upstream]
	end

	def lots
	end

	def baseline
		Confetti.CSpec(nexp[:baseline].to_s)
	end

	def baseline=
	end

	def products
		raise "unimplemented"
	end

	#-------------------------------------------------------------------------------------------

	def cspec
	end

	#-------------------------------------------------------------------------------------------

	def write(path)
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

	private :is, :create
	private_class_method :new
end # Project

def self.ProjectConfig(*args)
	x = Project.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

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

		@branch = Confetti.Branch(row[:branch])
		@cspec = Confetti.CSpec(row[:cspec]) if !row[:cspec].empty? # what for?

		@ctl_view = Confetti.ProjectControlView(self)

		assert_ready
	end

	def create(name, *opt, branch: nil, cspec: nil, lspec: nil)
		raise "invalid project name" if name.to_s.strip.empty?

		@name = name
		raise "Project #{name} exists." if exist?

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@cspec = Confetti.CSpec(cspec) if cspec
		@lspec = Confetti.LSpec(lspec) if lspec

		create_db_record # should use transaction here
		create_control_view
		create_config_files

		assert_ready

#		rescue Exception => x
#			raise "failed to create project #{name}: " + x.to_s
	end

	def create_from_project(name, *opt, branch: nil, from_project: nil)
		raise "invalid project name" if name.to_s.strip.empty?
		raise "invalid source project specification" if !from_project

		@name = name
		raise "Project #{name} exists." if exist?

		@branch = Confetti.Branch(!branch ? std_branch_name : branch)
		@cspec = from_project.cspec.dup if from_project.cspec
		@lspec = from_project.lspec.dup if from_project.lspec

		create_db_record # should use transaction here
		create_control_view
		create_config_files

		assert_ready

#		rescue Exception => x
#			raise "failed to create project #{name}: " + x.to_s
	end

	#------------------------------------------------------------------------------------------
	# construction
	#------------------------------------------------------------------------------------------

	def exist?
		!!Confetti::DB.global.single("select * from projects where name=?", [@name])
	end

	def create_db_record
		Confetti::DB.global.execute("insert into projects (name, branch, cspec) values (?, ?, ?)",
			[@name, @branch.name, @cspec.to_s])
	end

	def create_control_view
		@ctl_view = ProjectControlView.create(self)
	end

	@@project_config_t = <<-END
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
		config = Bento.mold(@@project_config_t, binding)

		FileUtils.mkdir_p(config_path)

		path = main_config_file
		File.write(path, config)
		@ctl_view.add_files(path)

		path = lots_config_file
		File.write(path, @lspec)
		@ctl_view.add_files(path)
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

	def ctl_view
		return @ctl_view if @ctl_view
		@ctl_view = Confetti.ProjectControlView(self, :ready)
	end

	def config_path
		Config.path_in_view(ctl_view)
	end

	def config_file(file)
		config_path + "/" + file
	end

	def main_config_file
		config_file("project.ne")
	end

	def lots_config_file
		config_file("lots.ne")
	end

	def config_nexp
		return @project_ne if @project_ne
		@project_ne = Nexp::Nexp.from_file(main_config_file, :single)
	end

	def lspec
		Confetti::LSpec.from_file(lots_config_file)
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
