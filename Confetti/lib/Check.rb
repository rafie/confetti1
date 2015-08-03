
require_relative 'Common'
require_relative 'Database'

module Confetti

#----------------------------------------------------------------------------------------------

module DB

class Check < ActiveRecord::Base
end

end # module DB

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
		row = DB::Check.find_by(name: @name)
		from_row(row)
	end

	def create(name, *opt, cspec: nil, user: nil)
		raise "check: unspecified name" if name.empty?
		raise "check: unspecified cspec" if cspec == nil

		@name = name
		@cspec = cspec
		@user = System.user.downcase if user == nil
		
		row = DB::Check.new do |r|
			r.name = @name
			r.user = @user.to_s
			r.cspec = @cspec.to_s
		end
		row.save

		rescue Exception => x
			puts x.message
			puts x.backtrace.inspect
			raise "Check: failed to add check with name='#{@name}' (already exists?)"
	end

	def from_row(row)
		fail "check: invalid row (name='#{@name}')" if row == nil
		@name = row.name if !@name
		@cspec = Confetti.CSpec(row.cspec)
		@user = User.new(row.user)
	end
	
	private :from_row

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
