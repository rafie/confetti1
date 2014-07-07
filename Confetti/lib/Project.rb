
require_relative 'Confetti'
require_relative 'Stream'

module Confetti

#----------------------------------------------------------------------------------------------

class Project < Stream
	attr_reader :name
	attr_writer :cspec

	def initialize(name)
		@name = name
		@branch = ''
		@root_vob = ''
	end

	def new_activity(name, project, version: nil)
	end

	def cspec=(s)

	end

	def check!
	end

	def new_version
	end

	def Project.create(name, branch: nil, root_vob: nil, cspec: nil)
		# create management view
		# establish project ne
		# create db record
	end

	private

	# management view
	def mview
	end

	def label
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

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
