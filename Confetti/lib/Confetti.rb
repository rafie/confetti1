
require_relative 'Common'
require 'byebug'

module Confetti

#----------------------------------------------------------------------------------------------

class User
	attr_reader :name

	def initialize(name)
		@name = name.to_s.downcase
	end

	def to_s
		@name
	end

	def self.current
		User.new(System.user)
	end
end # User

#----------------------------------------------------------------------------------------------

class Config
	def Config.db_path
		if !Confetti.test_mode?
			view = ClearCASE.CurrentView
			path = "R:/Build/cfg"
		else
			path = Test.root + "/net"
		end
		path + "/confetti"
	end

	def Config.path_in_view(view = nil)
		if !Confetti.test_mode? || TEST_WITH_CLEARCASE
			view = Confetti.CurrentView() if !view
		else
			view = Confetti.TestView('') if !view
		end

		view.path + "/nbu.meta/confetti"
	end
end # Config


#----------------------------------------------------------------------------------------------

class DB

	@@global_db = nil
	
	def DB.global
		if DB.global_db == nil
			if !Confetti.test_mode?
				db = Bento::DB.new(DB.global_path)
			else
				db = Bento::DB.create(path: DB.global_path, 
					schema: '../db/global.schema.sql', 
					data: Config.db_path + '/global.data.sql')
				System.command("ruby init.rb", at: Config.db_path)
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
		if !Confetti.test_mode?
			Config.db_path + "/global.db"
		else
			Config.db_path + "/global.db"
		end
	end

	def DB.cleanup
#		puts @@global_db.path + " cleanup"
		if Confetti.test_mode?
			DB.global_db.cleanup if @@global_db
			@@global_db =  nil
		end
	end

	def DB.connect
		byebug
		if @@global_db == nil
			ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DB.global_path)
		end
	end

	DB.connect

	def DB.global_db
		@@global_db
	end

end # DB

#----------------------------------------------------------------------------------------------

end # module Confetti
