
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Check
	include Bento::Class

	constructors :is, :create
	members :id, :name, :cspec, :user

	attr_reader :name, :cspec, :user

	#------------------------------------------------------------------------------------------

	def is(name, *opt)
		raise "check: invalid name" if name.empty?
		@name = name
		row = db.one("select id, name, user, cspec from views where name=?", @name)
		from_row(row)
	end

	def create(name, *opt, cspec: nil, user: nil)
		raise "check: unspecified name" if name.empty?
		raise "check: unspecified cspec" if cspec == nil

		@name = name
		@cspec = cspec
		@user = System.user.downcase if user == nil
		
		@id = db.insert(:checks, %w(name user cspec), @name, @user, @cspec)
	end

	def from_row(row)
		fail "view: invalid row" if row == nil
		@id = row[:id]
		@name = row[:name] if !@name
		@cspec = Confetti.CSpec(row[:cspec])
		@user = User.new(row[:user])
	end
	
	private :from_row

	#------------------------------------------------------------------------------------------

	def db
		Confetti::DB.global
	end

end

#----------------------------------------------------------------------------------------------

class Checks
	include Enumerable

	attr_reader :names

	def initialize(names, *opt)
		@names = names
	end

	def count
		@names.count
	end

	def each
		@names.each { |name| yield Confetti.Check(name) }
	end
end

#----------------------------------------------------------------------------------------------

end
