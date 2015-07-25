
require_relative 'Common'
require_relative 'Config'
require_relative 'Branch'
require_relative 'CSpec'
require_relative 'User'

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

	attr_reader :nick, :name

	#------------------------------------------------------------------------------------------	

	def is(nick, *opt, name: nil)
		init_flags([:raw], opt)
		opt1 = filter_flags([:raw], opt)

		nick = nick.to_s
		name = name.to_s
		
		no_nick = nick.empty?
		no_name = name.empty?
		raise "View: empty name" if no_nick && no_name
		## raise "View: conflicting name/nick" if !no_nick && !no_name # this is ok
		
		if !no_nick
			rows = DB::View.where(nick: nick, user: CurrentUser.new.name)
			raise "View: no view nicknamed '#{nick}'" if rows.count == 0
			raise "View: nickname '#{nick}' is not unique" if rows.count > 1
			row = rows[0]
		else
			row = DB::View.find_by(name: name)
		end

		from_row(row)

		# when outside the box, root_vob is nil
		# when inside the box, root_vob is box'es vob
		@view = ClearCASE.View(nil, *opt1, name: name, root_vob: Config.root_vob)
	end

	#------------------------------------------------------------------------------------------	

	def create(nick, *opt, name: nil, cspec: nil)
		init_flags([:raw, :nop], opt)
		opt1 = filter_flags([:raw, :nop], opt)

		raise "View: invalid cspec" if !cspec

		nick = nick.to_s
		name = name.to_s

		nick = Bento.rand_name if nick.empty? && name.empty?

		@nick = nick.empty? ? name : nick
		@name = @raw ? nick : CurrentUser.new.name + "_" + nick if name.empty?

		@view = ClearCASE::View.create(nil, *opt1, name: @name, root_vob: Config.root_vob)
		Config.box.add_view @view if Config.box

		return if @nop

		row = DB::View.new do |r|
			r.name = @name
			r.nick = @nick
			r.user = CurrentUser.new.name
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
		@name = row.name
		@user = User.new(row.user)
		@cspec = Confetti.CSpec(row.cspec)
	end

	#-------------------------------------------------------------------------------------------

	def path
		@view.path
	end

	def root
		@view.root
	end

	def internal
		@view
	end

	def to_s
		@name
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

	def remove!
		@view.remove!
		Config.box.remove_view @view if Config.box
	end
end

#----------------------------------------------------------------------------------------------

class Views
	include Enumerable

	attr_reader :names

	def initialize(names = [])
		@names = names
	end

	def each
		@names.each { |name| yield Confetti.View(nil, name: name) }
	end
	
	def <<(view)
		@names << view.to_s
	end
	
	def delete(view)
		@names.delete(view.to_s)
	end
	
	def empty?
		@names.empty?
	end

	def shift
		@names.shift
	end

#	def first
#		Confetti.View(nil, name: @names.first)
#	end

end # Views

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
