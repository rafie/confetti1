
require 'sqlite3'
require 'active_record'
require 'byebug'

#----------------------------------------------------------------------------------------------

class Database
	DB_NAME = 'db1.db'

	@@db = nil
	@@in_connect = false
	
	def self.connect
		return if @@in_connect
		return if @@db

		@@in_connect = true

		ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DB_NAME)
		raise "Cannot connect to database" if !ActiveRecord::Base.connection.active?
		begin
			# rows = ActiveRecord::Base.connection.execute("select * from sqlite_sequence")
			db = SQLite3::Database.new(DB_NAME)
			rows = db.execute("select * from sqlite_sequence")
		rescue
			Schema.migrate(:up)
		end
		@@db = ActiveRecord::Base.connection
		@@in_connect = false
	end

	def self.connected?
		@@db != nil
	end
	
	def self.db
		@@db
	end
		
end

#----------------------------------------------------------------------------------------------

module ActiveRecord
module ConnectionHandling
	alias_method :old_retrieve_connection, :retrieve_connection
	
	def retrieve_connection
		Database.connect
		old_retrieve_connection
	end
end
end

#----------------------------------------------------------------------------------------------

class Schema < ActiveRecord::Migration
	def up
		create_table :checks do |t|
			t.column :name, :string
		end
	end
end

class Check < ActiveRecord::Base
end

#----------------------------------------------------------------------------------------------

# Database.connect

row = Check.new do |r|
	r.name = "abc"
end
row.save
