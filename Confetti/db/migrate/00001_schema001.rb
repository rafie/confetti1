
require 'active_record'

class Schema001 < ActiveRecord::Migration
	def up
		#--------------------------------------------------------------------------------------

		create_table :views do |t|
			t.column :name, :string
			t.column :user, :string
			t.column :cspec, :string
		end

		add_index :views, :name, unique: true

		#--------------------------------------------------------------------------------------

		create_table :activities do |t|
			t.column :name, :string    
			t.column :view_id, :integer
			t.column :branch, :string
			t.column :project_id, :integer
			t.column :user, :string
			t.column :cspec, :string
			t.column :icheck, :integer
		end

		add_index :activities, :name, unique: true

		#--------------------------------------------------------------------------------------

		create_table :checks do |t|
			t.column :name, :string
			t.column :user, :string
			t.column :cspec, :string
		end

		add_index :checks, :name, unique: true

		#--------------------------------------------------------------------------------------

		create_table :projects do |t|
			t.column :name, :string
			t.column :branch, :string
		end

		add_index :projects, :name, unique: true

		#--------------------------------------------------------------------------------------

		create_table :project_versions do |t|
			t.column :project_id, :integer
			t.column :version, :string
			t.column :cspec, :string
		end

		#add_index :project_versions, [:project_id, :version], unique: true

		#--------------------------------------------------------------------------------------

		create_table :products do |t|
			t.column :name, :string
		end

		add_index :products, :name, unique: true

		#--------------------------------------------------------------------------------------

		create_table :product_versions do |t|
			t.column :product_id, :integer
			t.column :name, :string
		end
		
		add_index :product_versions, [:product_id, :name], unique: true

		#--------------------------------------------------------------------------------------
	end
end
