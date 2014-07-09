

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
			if !CONFETTI_TEST
				db = Bento::DB.new(DB.global_path)
			else
				db = Bento::DB.create(schema: '../db/global.schema.sql', data: 'net/confetti/global.data.sql')
			end
			class_variable_set(:@@global_db, db)
		end
		DB.global_db
	end
	
	def DB.global_path
		if !CONFETTI_TEST
			Config.db_path + "/global.db"
		else
			Config.db_path + "/global.db"
		end
	end

	def DB.cleanup
		if CONFETTI_TEST
			DB.global_db.cleanup
			class_variable_set(:@@global_db, nil)
		end
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
