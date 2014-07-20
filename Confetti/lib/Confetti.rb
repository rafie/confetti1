

require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class User
	attr_reader :name

	def initialize(name)
		@name = name
	end

end # User

#----------------------------------------------------------------------------------------------

class DB

	@@global_db = nil

	def DB.global_db
		@@global_db
	end

	def DB.global
		if DB.global_db == nil
			if !TEST_MODE
				db = Bento::DB.new(DB.global_path)
			else
				db = Bento::DB.create(path: DB.global_path, 
					schema: '../db/global.schema.sql', 
					data: Config.db_path + '/global.data.sql')
			end
			class_variable_set(:@@global_db, db)
		else
			if DB.global_path != @@global_db.path
				DB.cleanup
				DB.global # recursively try again
			end
		end
		DB.global_db
	end
	
	def DB.global_path
		if !TEST_MODE
			Config.db_path + "/global.db"
		else
			Config.db_path + "/global.db"
		end
	end

	def DB.cleanup
#		puts @@global_db.path + " cleanup"
		if TEST_MODE
			DB.global_db.cleanup
			@@global_db =  nil
		end
	end

end # DB

#----------------------------------------------------------------------------------------------

class Config
	def Config.db_path
		if !TEST_MODE
			view = ClearCASE::CurrentView.new
			path = "R:/Build/cfg"
		else
			path = Test.current.path + "/net"
		end
		path + "/confetti"
	end

	def Config.view_path(view_name = nil)
		if !TEST_MODE
			if !view_name
				view = ClearCASE::CurrentView.new
			else
				view = ClearCASE::View.new(view_name)
			end
			path = view.fullPath
		else
			path = Test.current.path + "/"
			path += !view_name ? "view" : "views/#{view_name}"
		end
		path += "/nbu.meta/confetti"
		FileUtils.mkdir_p(path) if !File.directory?(path)
		path
	end
end # Config


#----------------------------------------------------------------------------------------------

end # module Confetti
