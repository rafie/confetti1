
require_relative 'Confetti'
require_relative 'Stream'
require_relative 'CSpec'
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

	@@ne_template = <<-END
(project <%= @name %>
	(baseline 
		<%= cspec.to_s %>)
	:itag 0
	:icheck 0
	(lots 
		<%for lot in @lots %> <%= lot %> <% end %>))
END

	#------------------------------------------------------------------------------------------

	def is(name, *opt, db_row: nil)
		@name = name
		@row = db_row if !!db_row

		@branch = row[:branch]
		@cspec = row[:cspec]

		@ctl_view = Confetti.ProjectControlView(project_name: @name, branch: @branch)

		assert_ready
	end

	def create(name, *opt, branch: nil, cspec: nil, lspec: nil)
		raise "invalid project name" if name.to_s.strip == ''

		@name = name
		@branch = name + "_int_br" if !branch
		@cspec = Confetti.CSpec(cspec) if cspec
		@lspec = Confetti.Lots.from_file(lspec) if lspec

		# create db record
		Confetti::DB.global.execute("insert into projects (name, branch, cspec) values (?, ?, ?)",
			[@name, @branch, cspec])

		# create control view
		@ctl_view = ProjectControlView.create(project_name: @name, branch: @branch)

		# establish project ne
		@lots = @cspec.lots.keys
		project_ne = ERB.new(@@ne_template, 0, "-").result(binding)
		File.write(Config.view_path(@ctl_view.name) + '/project.ne', project_ne)

		assert_ready

#		rescue Exception => x
#			byebug
#			raise "failed to create project"
	end

	def create_from_project(name, *opt, branch: nil, project: nil)
		raise "unimplemented"
		assert_ready
	end

	def assert_ready
#		byebug
#		raise "not ready" if !@name || !@row || !@branch || !@ctl_view || !@cspec
	end

	def self.current
		CurrentProject.new
	end

	#------------------------------------------------------------------------------------------

	def new_activity(name, project, version: nil)
	end

	def lots
		Lots.new(~db[:lots])
	end

#	def cspec
#		@cspec.to_s
#	end

	def cspec=(s)
		@cspec = Confetti.CSpec(s)
	end

	def check!
	end

	def new_version!
	end

	def tag!
	end

	def local_db_file
		Config.view_path + '/project.ne'
	end

	#------------------------------------------------------------------------------------------

	# control view
	def ctl_view
		return @ctl_view if @ctl_view
		@ctl_view = Confetti.ProjectControlView(name, :ready)
	end

	def db
		return @project_ne if @project_ne
		@project_ne = Nexp::Nexp.from_file(Config.view_path(ctl_view.name) + '/project.ne', :single)
	end

	def row
		@row = Confetti::DB.global.single("select * from projects where name=?", [@name]) if !@row
		@row
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

	private :db, :row, :assert_ready

	private :is, :create, :create_from_project
	private_class_method :new
end # Project

def self.Project(*args)
	x = Project.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class CurrentProject < Project

	def initialize
		@db = nil
	end

	def is

	end

	def version
		db.version
	end

	private

	def db
		Nexp::Nexp.from_file(Config.view_path(ctl_view.name) + '/project.ne', :single)
	end

	class DB
		def initialize
			view = ClearCASE::CurrentView.new
			@ne = Nokogiri::XML(File.open(view.fullPath + PROJECT_NEXP_VIEWPATH))
		end

		def version
			@xml.xpath("/project/@version").to_s
		end

		def roots(name)
			@xml.xpath("//lots/lot[@name='#{name}']/vob/@name").map { |x| x.to_s }
		end
	
	end # DB

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
