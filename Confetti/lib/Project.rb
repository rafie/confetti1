
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

	attr_reader :name, :branch, :root_vob
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

	def initialize(name, *opt, db_row: nil,
			branch: nil, root_vob: nil, cspec: nil)
		return if tagged_init(:create, opt, [name, *opt, branch: branch, root_vob: root_vob, cspec: cspec])

		@name = name
		@row = db_row if !!db_row
		if row == nil
			byebug
		end

		@branch = row[:branch]
		@root_vob = row[:root_vob]

	end

	def Project.create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
		Project.new(name, *opt << :create, branch: branch, root_vob: root_vob, cspec: cspec)
	end

	#------------------------------------------------------------------------------------------

	def new_activity(name, project, version: nil)
	end

	def lots
		Lots.new(~db[:lots])
	end

	def cspec
		@cspec.to_s
	end

	def cspec=(s)
		@cspec = CSpec.new(s)
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
	private

	def create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
		raise "invalid project name" if name.to_s.strip == ''

		@name = name
		@branch = name + "_int_br" if !branch
		@root_vob = root_vob.to_s
		@cspec = CSpec.new(cspec) if cspec

		# create db record
		Confetti::DB.global.execute("insert into projects (name, branch, root_vob, cspec) values (?, ?, ?, ?)",
			[@name, @branch, @root_vob, cspec])

		# create control view
		@ctl_view = ProjectControlView.create(project_name: @name, branch: @branch, root_vob: @root_vob)

#		byebug

		# establish project ne
		@lots = @cspec.lots.keys
		project_ne = ERB.new(@@ne_template, 0, "-").result(binding)
		File.write(Config.view_path(@ctl_view.name) + '/project.ne', project_ne)

#		rescue Exception => x
#			byebug
#			raise "failed to create project"
	end

	# control view
	def ctl_view
		return @ctl_view if @ctl_view
		if !TEST_MODE
			@ctl_view = View.new(".project_#{@name}", :ready)
		else
			@ctl_view = ProjectControlView.new(name)
		end
	end

	def db
		Nexp.from_file(Config.view_path(ctl_view.name) + '/project.ne', :single)
	end

	def row
		@row = Confetti::DB.global.single("select * from projects where name=?", [@name]) if !@row
		@row
	end

end # Project

#----------------------------------------------------------------------------------------------

class CurrentProject < Project

	def initialize
		@db = nil
	end

	def version
		db.version
	end

	private

	def db
		@db = DB.new if ! @db
		@db
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

#----------------------------------------------------------------------------------------------

class Projects
	include Enumerable

	def initialize(names)
		@names = names
	end

	def each
		@names.each { |name| yield Proejct.new(name) }
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
		@rows.each { |row| yield Project.new(row[:name], db_row: row) }
	end

	def db
		Confetti::DB.global
#		Nexp.from_file(Confetti::Config.view_path + "/projects.ne", :single)
	end

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
