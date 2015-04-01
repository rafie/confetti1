
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Database

	@@global_db = nil
	
	def self.db_path
		Config.db_path
	end

	def self.cleanup
	end

	def self.connect
		return if @@global_db
		ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: Database.db_path)
		raise "Cannot connect to database #{Database.db_path}" if !ActiveRecord::Base.connection.active?
		begin
			rows = ActiveRecord::Base.connection.execute("select * from sqlite_sequence")
		rescue
			create
			# raise "Cannot connect to database #{Database.db_path}"
		end
		@@global_db = true
	end

#	Database.connect

	def self.connected?
		@@global_db != nil
	end

	def self.global_db
		@@global_db
	end

	def self.create
		migrate
	end

	def self.migrate
		ActiveRecord::Migrator.migrate(Config.confetti_path + "db/migrate")
	end

	def self.dumpSchema
	end
	
	def self.dump
	end

end # Database

#----------------------------------------------------------------------------------------------

end # module Confetti

#----------------------------------------------------------------------------------------------

module ActiveRecord
module ConnectionHandling

	@@connected = false

	# TODO: consider using alias or alias_method
		
	def retrieve_connection
		if !@@connected
			@@connected = true
			Confetti::Database.connect
		end

		connection_handler.retrieve_connection(self)
	end
end
end

#----------------------------------------------------------------------------------------------
