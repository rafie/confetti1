

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
		class_variable_get(:@@global_db)
	end

	def DB.global
		if DB.global_db == nil
			class_variable_set(:@@global_db, SQLite3::Database.new(DB.global_path))
			DB.global_db.results_as_hash = true
		end
		DB.global_db
	end
	
	def DB.global_path
		Config.db_path + "/global.db"
	end

end # DB

#----------------------------------------------------------------------------------------------

class Config
	def Config.db_path
		if !CONFETTI_TEST
			view = ClearCASE::CurrentView.new
			path = "R:/Build/cfg"
		else
			path = "net"
		end
		path + "/confetti"
	end

	def Config.view_path
		if !CONFETTI_TEST
			view = ClearCASE::CurrentView.new
			path = view.fullPath
		else
			path = "view"
		end
		path + "/nbu.meta/confetti"
	end
end # Config

#----------------------------------------------------------------------------------------------

end # module Confetti
