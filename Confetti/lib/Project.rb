
require_relative 'Confetti'
require_relative 'Stream'

module Confetti

#----------------------------------------------------------------------------------------------

class Project < Stream
	include Bento::Class

	attr_reader :name
	attr_writer :cspec

	def initialize(name, *opt, row: nil)
		return if tagged_init(:create, opt, [name, *opt])

		@name = name
		@branch = '' # take from db
		@root_vob = '' # take from db
	end

	def new_activity(name, project, version: nil)
	end

	def cspec=(s)

	end

	def check!
	end

	def new_version!
	end

	def tag!
	end

	def Project.create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
		# create db record
		# establish project ne
		# create control view
	end

	def by_row(row, *opt)
		
	end

	private

	def create(name, *opt, branch: nil, root_vob: nil, cspec: nil)
	end

	# control view
	def ctl_view
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
		@rows = db.execute("select name from projects")
		fail "Cannot determine all projets" if @rows == nil
	end

	def each
		@rows.each { |row| yield Project.new(row["name"]) }
	end

	def db
		Confetti::DB.global
#		Nexp.from_file(Confetti::Config.view_path + "/projects.ne", :single)
	end

	def Projects.create(name, cspec: nil, branch: nil, roov_vob: nil)
		branch = name + "_int_br" if !branch
		root_vob = root_vob.to_s
		stm = Confetti::DB.global.execute("insert into projects (name, branch, root_vob, cspec) values (?, ?, ?, ?)",
			[name, branch, root_vob, cspec])

#		q = DB::Query.new("insert into projects (name, branch, root_vob, cspec) values (?, ?, ?, ?)"), 
#			name, branch, root_vob, cspec
#		q.exec!
		rescue
			raise "failed to create project"
	end
end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
