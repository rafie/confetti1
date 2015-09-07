
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Database

	@@db = nil
	@@db1 = nil
	@@in_connect = false
	@@log = nil
	@@migration_log = nil
	@@migration_scripts = []

	#------------------------------------------------------------------------------------------
		
	def self.db_path
		Config.db_path
	end

	def self.db_source
		Config.confetti_root/"db"
	end

	#------------------------------------------------------------------------------------------

	def self.activerecord_log_path
		Config.db_log_path/'activerecord.log'
	end

	def self.migration_log_path
		Config.db_log_path/'migration.log'
	end

	def self.migration_log
		@@migration_log
	end

	#------------------------------------------------------------------------------------------
	
	def self.cleanup
	end

	#------------------------------------------------------------------------------------------
	
	def self.connect
		return if @@in_connect
		return if @@db
		@@in_connect = true

		@@log = Logger.new(activerecord_log_path)
		@@migration_log = File.open(migration_log_path, 'a')
		
		ActiveRecord::Base.logger = @@log
		ActiveSupport::LogSubscriber.colorize_logging = false
		ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: Database.db_path)
		bb
		raise "Cannot connect to database #{Database.db_path}" if !ActiveRecord::Base.connection.active?

		internal_create if !ready?

		@@db = ActiveRecord::Base.connection
		@@in_connect = false
	end

	def self.close
		bb
		@@migration_log.close if @@migration_log
		@@log.close
		db1.close
		@@db1 = nil
		ActiveRecord::Base.connection_pool.disconnect!
		@@db = nil
	end

	#------------------------------------------------------------------------------------------
	
	def self.connected?
		@@db != nil
	end

	def self.db
		@@db
	end

	def self.db1
		return @@db1 if @@db1
		@@db1 = Bento.DB(path: Database.db_path)
	end

	def self.ready?
		begin
			# for a pretty strange bug, we cannot use ActiveRecord::Base.connection.execute here
			# rows = ActiveRecord::Base.connection.execute("select * from sqlite_sequence")
			rows = db1.execute("select * from sqlite_sequence")
			true
		rescue
			false
		end
	end

	#------------------------------------------------------------------------------------------
	
	def self.create
		connect
	end

	#------------------------------------------------------------------------------------------
	
	def self.migrate
		ActiveRecord::Migrator.migrate(db_source/"migrate")
		@@migration_scripts.each do |file|
			execute_script(file)
		end
	end

	def self.migration_sql_script(schema_path)
		sql_script_path = Pathname.new(schema_path).newext(".sql")
		@@migration_scripts << sql_script_path if sql_script_path.exist?
	end

	#------------------------------------------------------------------------------------------
	
	def self.execute_script(file)
		db1 << File.read(file)
	end

	#------------------------------------------------------------------------------------------
	
	def self.dumpSchema
	end
	
	def self.dump
	end
	
	#------------------------------------------------------------------------------------------
	
	private
	
	def self.internal_create
		begin
			migrate
#			data_script = db_source/"data.sql"
#			execute_script(data_script) if File.exist?(data_script)
		rescue
			raise "Creating database #{Database.db_path} failed"
		end
	end

end # Database

#----------------------------------------------------------------------------------------------

end # module Confetti

#----------------------------------------------------------------------------------------------

module ActiveRecord

#----------------------------------------------------------------------------------------------

module ConnectionHandling
	alias_method :old_retrieve_connection, :retrieve_connection
		
	def retrieve_connection
		Confetti::Database.connect
		old_retrieve_connection
	end
end

#----------------------------------------------------------------------------------------------

class Migration
    def write(text="")
      return if !verbose
      log = Confetti::Database.migration_log
      if log
      	log.puts(text)
      	log.flush
      else
      	puts text
      end
    end 
end

#----------------------------------------------------------------------------------------------

end # module ActiveRecord

#----------------------------------------------------------------------------------------------
