
require 'sqlite3'
require 'active_record'
require 'byebug'

module A

class Database
	@@db = nil
	@@in_connect = false
	
	def self.connect
		return if @@in_connect
		@@in_connect = true
		return if @@db

		ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'etc/t2.db')
		raise "Cannot connect to database" if !ActiveRecord::Base.connection.active?
		begin
			rows = ActiveRecord::Base.connection.execute("select * from sqlite_sequence")
		rescue
			Schema001.migrate(:up)
		end
		@@db = true
		@@in_connect = false
	end

	def self.connected?
		@@db != nil
	end
end

end # module A

module ActiveRecord
module ConnectionHandling
	
	alias old_retrieve_connection retrieve_connection
	
	@@connected = false
	
	def retrieve_connection
		puts "ActiveRecord::ConnectionHandling::retrieve_connection"
		if !@@connected
			A::Database.connect
			@@connected = true
		end
		old_retrieve_connection
	end
	
	def retrieve_connection2
		puts "ActiveRecord::ConnectionHandling::retrieve_connection"
		old_retrieve_connection
	end
end
end

class Schema001 < ActiveRecord::Migration
	def up
		create_table :checks do |t|
			t.column :name, :string
		end
	end
end

puts "connect"
# A::Database.connect
puts "after connect"

class Check < ActiveRecord::Base
end

puts "abc"
row = Check.new do |r|
	r.name = "abc"
end
row.save

puts "abc1"
row = Check.new do |r|
	r.name = "abc1"
end
row.save

puts "abc2"
row = Check.new do |r|
	r.name = "abc2"
end
row.save
