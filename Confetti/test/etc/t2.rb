
require 'sqlite3'
require 'active_record'
require 'byebug'

module ActiveRecord
  module ConnectionHandling
    @@connected = false

    def retrieve_connection
      byebug
      if !@@connected
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 't2.db')
        @@connected = true
      end
      connection_handler.retrieve_connection(self)
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

class Base < ActiveRecord::Base

	def initialize
		byebug
		Database.connect
		super
	end

	def find_by
		byebug
		Database.connect
		super
	end
end

# Schema001.migrate(:up)

class A
	def initialize
		puts "A"
	end
end

class B < A
	def initialize
		super
		puts "B"
	end
end

b = B.new

class Check < ActiveRecord::Base
	def initialize
		byebug
		super
	end
end

byebug
row = Check.new do |r|
	r.name = "abc"
end
row.save
