
require 'nokogiri'
require 'Bento'

module Confetti

PROJECT_XML_VIEWPATH = "/nbu.meta/confetti/project.xml"

#----------------------------------------------------------------------------------------------

class Project
	attr_reader :name, :roots
	attr_writer :roots

	def initialize(name)
		@name = name
		@roots = []
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
			@xml = Nokogiri::XML(File.open(view.fullPath + PROJECT_XML_VIEWPATH))
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

	def initialize
		@rows = db.execute("select name from projects")
		fail "Cannot determine all projets" if @rows == nil
	end

	def each
		@rows.each { |row| yield Project.new(row["name"]) }
	end

	def db
		Confetti::DB.global
	end

end # Projects

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
