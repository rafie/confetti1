
require 'erb'

require_relative 'Confetti'
# require 'Bento'
require_relative 'Stream'

module Confetti

#----------------------------------------------------------------------------------------------

# (project project-name
# 	(baseline cspec)
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

	@@ne_template = %{
	(project <%= @name %>
		(baseline <%= cspec.to_s %>)
		:itag 0
		:icheck 0
		(lots 
			<%for @lot in @lots -%>
			<%= @lot %>
			<% end -%>))
	}

	def initialize(name, *opt, row: nil)
		return if tagged_init(:create, opt, [name, *opt])

		@name = name

		row = Confetti::DB.global.single("select * from projects where name=?", [name]) if !row
		@branch = row[:branch]
		@root_vob = row[:root_vob]
	end

	def new_activity(name, project, version: nil)
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

	def Project.create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
		raise "invalid project name" if name.to_s.strip == ''

		@cspec = CSpec.from_file(cspec) if cspec

		# create db record
		branch = name + "_int_br" if !branch
		root_vob = root_vob.to_s

		Confetti::DB.global.execute("insert into projects (name, branch, root_vob, cspec) values (?, ?, ?, ?)",
			[name, branch, root_vob, cspec])

		# create control view
		view = View.create('.project_' + name, root_vob: root_vob)

		# establish project ne
		project_ne = ERB.new(@ne_template, 0, "%<>").result(binding)
		File.write(Config.view_path(view) + '/project.ne', project_ne)

		Project.new(name)

		rescue
			raise "failed to create project"
	end

	def by_row(row, *opt)
		
	end

	def local_db_file
		Config.view_path + '/project.ne'
	end

	#------------------------------------------------------------------------------------------
	private

	def create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
	end

	# control view
	def ctl_view
		if !TEST_MODE
			ClearCASE::View.new(".project_#{@name}", :ready)
		else
			nil
		end
	end

	def db
		Nexp.from_file(Config.view_path + '/project.ne', :single)
	end

	def global_db
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
		@rows = db["select * from project"]
		fail "Cannot determine all projets" if @rows == nil
	end

	def each
		@rows.each { |row| yield Project.new(row[:name], row: row) }
	end

	def db
		Confetti::DB.global
#		Nexp.from_file(Confetti::Config.view_path + "/projects.ne", :single)
	end

	def Projects.create(name, cspec: nil, branch: nil, roov_vob: nil)
		branch = name + "_int_br" if !branch
		root_vob = root_vob.to_s
		Confetti::DB.global.execute("insert into projects (name, branch, root_vob, cspec) values (?, ?, ?, ?)",
			[name, branch, root_vob, cspec])
		rescue
			raise "failed to create project"
	end
end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
