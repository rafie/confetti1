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
	members :id, :raw, :nick, :name, :view

	attr_reader :name

	#------------------------------------------------------------------------------------------	

	def is(nick, *opt, name: nil)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		raise "View: empty name" if nick.to_s.empty? && name.to_s.empty?
		raise "View: conflicting name/nick" if !nick.to_s.empty? && !name.to_s.empty?
		
		byebug
		
		username = Confetti.User.name
		if nick
			rows = DB::View.where(nick: nick.to_s, user: username)
			raise "View: no view nicknamed '#{nick}'" if rows.count == 0
			raise "View: nickname '#{nick}' is not unique" if rows.count > 1
			row = rows[0]
		else
			row = DB::View.find_by(name: name.to_s)
		end

		@name = name.to_s

		
		from_row(row)

		@view = ClearCASE.View(nil, *opt1, name: name, root_vob: Config.root_vob)

		@name = @view.name
	end

	#------------------------------------------------------------------------------------------	

	def create(nick, *opt, name: nil, cspec: nil)
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

	#------------------------------------------------------------------------------------------	

	def from_row(row)
		fail "View: invalid row" if row == nil
		@nick = row.nick
		@user = User.new(row.user)
		@name = row.name
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
