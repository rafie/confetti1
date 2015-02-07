
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

module DB

class Product < ActiveRecord::Base
	has_many :product_versions, dependent: :destroy
end

end # module DB

#----------------------------------------------------------------------------------------------

class Product
	include Bento::Class

	constructors :is, :create
	members :id, :project

	def is(version, *opt, project: nil)
		raise "invalid project" if !project
	end

	def create(name, *opt, project: nil)
		raise "invalid project" if !project
	end

end

#----------------------------------------------------------------------------------------------

end
