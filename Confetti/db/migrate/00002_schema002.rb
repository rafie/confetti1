
require 'active_record'

class Schema002 < ActiveRecord::Migration
	def up
		#--------------------------------------------------------------------------------------

		add_column :views, :nick, :string

		add_index :views, :nick, unique: false

		#--------------------------------------------------------------------------------------

		add_column :activities, :nick, :string

		add_index :activities, :nick, unique: false
		add_index :activities, :user, unique: false

		#--------------------------------------------------------------------------------------
	end
end
