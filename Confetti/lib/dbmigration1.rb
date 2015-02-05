# gem install sqlite3
require 'rubygems'
require 'sqlite3'
require 'active_record'
def creating
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
	:adapter  => 'sqlite3',
	:database => 'c:/localConfetti.db' 
)

ActiveRecord::Schema.define do
unless ActiveRecord::Base.connection.tables.include? 'project_versions'
create_table :project_versions do |table|
	#table.column :pv_id,     :integer
	table.column :project_id,     :integer
	table.column :version,     :string
	table.column :cspec,     :string
end
end
unless ActiveRecord::Base.connection.tables.include? 'views'
create_table :views do |table|
	#table.column :vw_id,     :integer
	table.column :name, :string
	table.column :user,    :string
	table.column :cspec,   :string
end
end
unless ActiveRecord::Base.connection.tables.include? 'activities'
create_table :activities do |table|
	#table.column :act_id,     :integer
	table.column :view_id,    :integer
	table.column :name, :string    
	table.column :branch,   :string
	table.column :project_id,   :integer
	table.column :user,    :string
	table.column :cspec,   :string
	table.column :icheck,   :integer
end
end

unless ActiveRecord::Base.connection.tables.include? 'checks'
create_table :checks do |table|
	#table.column :ck_id,     :integer
	table.column :name, :string
	table.column :user,    :string
	table.column :cspec,   :string
end
end

unless ActiveRecord::Base.connection.tables.include? 'products'
create_table :products do |table|
	#table.column :prd_id,     :integer
	table.column :name, :string
end
end

end
end

class Activity< ActiveRecord::Base
	belongs_to :view 
end

class View < ActiveRecord::Base
	has_many :activities 
end
class Migrate < ActiveRecord::Migration
	def migrateDB
		add_column :activities, :custom, :string
	end 
end
def createActivity
	vw1= View.create(
	:name => 'Tool',
	:user => 'ToolViewUser',
	:cspec => 'ToolViewCspec'
)


vw1.activities.create(
	:name => 'Act1'
)
vw1.activities.create(
	:name => 'Act2'
)
vw1.activities.create(
	:name => 'Act3'
)
vw1.activities.create(
	:name => 'Act4'
)
vw1.activities.create(
	:name => 'Act5'
)
vw1.activities.create(
	:name => 'Act6'
)

end

def show_single_item
	a1 = View.find(1)
	puts "showing first view from the db below", a1.name
end

def show_all_items
	puts "showing all activities from the db below"
	pr = View.find(1)
	puts pr.cspec
	pr.activities.each do |ac|
		puts ac.name
	end

end
def migrate
	m=Migrate.new
	m.migrateDB()
end
def migration
creating
createActivity
show_single_item  
show_all_items  
migrate 
end
migration