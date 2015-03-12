require_relative 'Common'
require_relative 'Branch'

module Confetti

#----------------------------------------------------------------------------------------------

module DB

class View < ActiveRecord::Base
end

end # module DB

#----------------------------------------------------------------------------------------------

class View
	include Bento::Class

	constructors :is, :create
	members :id, :raw, :name, :view

	attr_reader :name

	def is(name, *opt)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "invalid name" if !name
		@name = name.to_s

		row = DB::View.find_by(name: @name)
		from_row(row)

		@view = ClearCASE.View(name, *opt1, root_vob: Config.root_vob)

		@name = @view.name
	end

	def create(name, *opt, cspec: nil)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)
		
		raise "invalid cspec" if !cspec

		@view = ClearCASE::View.create(name, *opt1, root_vob: Config.root_vob)
		
		Config.testenv.add_view @view if Config.testenv

		@name = @view.name

		row = DB::View.new do |r|
			r.name = @name
			r.user = User.current.to_s
			r.cspec = @cspec.to_s
		end
		row.save

		rescue Exception => x
			puts x.message
			puts x.backtrace.inspect
			raise "View: failed to add view with name='#{@name}' (already exists?)"
	end

	def from_row(row)
		fail "Unknown view: #{@name}" if row == nil
		@user = User.new(row.user)
		@name = row.name if !@name
		@cspec = Confetti.CSpec(row.cspec)
	end

	#-------------------------------------------------------------------------------------------

	def path
		@view.path
	end

	def root
		@view.root
	end

	def remove!
		@view.remove!
		Config.testenv.remove_view @view if Config.testenv
	end

	#-------------------------------------------------------------------------------------------

	def checkin(glob)
		@view.checkin(glob)
	end

	def checkout(glob)
		@view.checkout(glob)
	end

	def add_files(glob)
		@view.add_files(glob)
	end

	def label(name)
	end

	#-------------------------------------------------------------------------------------------

	def db
		Confetti::DB.global
	end
end

#----------------------------------------------------------------------------------------------

class CurrentView < View

	constructors :is
	members :view

	def is(*opt)
		@view = ClearCASE.CurrentView(root_vob: Config.root_vob)
	end

end # CurrentView

#----------------------------------------------------------------------------------------------

end # module Confetti
