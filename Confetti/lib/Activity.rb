
require 'Bento'

require 'Confetti/lib/Project'

module Confetti

#----------------------------------------------------------------------------------------------

class Activity
	include Bento::Class

	attr_reader :name, :user, :branch, :view

	#------------------------------------------------------------------------------------------

#	name
#	view
#	branch
#	project_id
#	user
#	cspec
#	icheck

	def _from_row(row)
		@id = row[:id]
		@view = Confetti.View(row[:view])
		@branch = Confetti.Branch(row[:branch])
		@user = User.new(row[:user])
		@project = Project(row[:project])
	end

	def is(name, *opt)
		init_flags([:raw], opt)

		@name = name
		raise "invalid name" if !@name
		
		row = db.single("select id, name, view, branch, user, project, project_id from activities join projects on id = project_id where name=?", @name)
		fail "Unknown activity: #{@name}" if row == nil
		_from_row(row)
	end

	def create(name, *opt, project: nil)
		byebug
		init_flags([:raw], opt)

		@name = name
		raise "invalid name" if !@name
		raise "create activity #{@name} failed: already exists" if exists?

		raise "invalid project" if !project

		@user = System.user.downcase if !@raw
		@name = "#{@user}_#{@name}" if !@raw
		@branch = Confetti::Branch.create(@name, :raw)
		@view = Confetti::View.create(@name, :raw)
		@project = project
		@last_check = 0

		view_args = {name: @view}
		view_args[:root_vob] = @root if @root

		ClearCASE::View.create(view_args)

		@id = db.insert(:activities, %w(name view branch project_id user cspec last_check),
			@name, @view, @branch, @project.id, @user, '', @last_check)
	end
	
	#------------------------------------------------------------------------------------------

	def exists?
		db.one("select count(*) from activities where name=?", name)[0] == 1
	end	
	
	#------------------------------------------------------------------------------------------

	def checkouts
		view.checkouts
	end
	
	def active_elements
		view.on_branch(branch)
	end

	#------------------------------------------------------------------------------------------

	def last_check
		db.get_first_value("select last_check from activities where name='#{@name}'")
	end

	def inc_check
		db.execute("update activities set last_check = last_check + 1 where name='#{@name}'")
		last_check
	end

	def last_check_name
		Activity.check_name(@name, last_check)
	end

	def new_check_name
		Activity.check_name(@name, inc_check)
	end

	def Activity.check_name(name, check)
		"#{name}_check_#{check}"
	end

	# flags: keepco

	def check!(lot = nil, *flags)
		lot = lot == nil ? nil : lot.is_a?(ClearCASE::Lot) ? lot : Lot.new(lot)
		keepco = flags.include?(:keepco)

		checkouts = view.checkouts
		checkouts = lot.filter_elements(checkouts) if lot
		checkin_done = false
		begin
			checkouts.checkin
			checkin_done = true
			
			bra_elements = view.on_branch(branch)
			bra_elements = lot.filter_elements(bra_elements) if lot
			return if bra_elements.empty?
			
			check_name = new_check_name
			bra_elements.label!(check_name, :recursive)
#		rescue => x
#			puts x
#			raise
		ensure
			checkouts.checkout if checkin_done && keepco
		end
	end	

	#------------------------------------------------------------------------------------------
	private
	#------------------------------------------------------------------------------------------
	
	def db
		Confetti::DB.global
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

	#-------------------------------------------------------------------------------------------

	private :is, :create
	private :_from_row
	private_class_method :new

end # Activity

def self.Activity(*args)
	x = Activity.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class Activities

	def initialize()
		@names = names
	end

	def each
		@names.each { |name| yield Activity.new(name) }
	end

end # Activities

#----------------------------------------------------------------------------------------------

class CurrentActivity < Activity

	def initialize
		view = CurrentView.new
		super(name: view.name)
	end

end # CurrentActivity

#----------------------------------------------------------------------------------------------

module All

#----------------------------------------------------------------------------------------------

class Activities

	def initialize(*opt)
		init([], [:user], [], opt)

		@rows = db["select name from activities"]
		fail "Cannot determine all activities" if @rows == nil
	end

	def each
		@rows.each { |row| yield Activity.new(row["name"]) }
	end

	def db
		Confetti::DB.global
	end

end # Activities

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
