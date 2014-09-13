
require 'Bento'

module Confetti

#----------------------------------------------------------------------------------------------

class Activity
	include Bento::Class

	attr_reader :name, :user, :branch, :view

	#------------------------------------------------------------------------------------------

	id integer PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,  
	name text NOT NULL UNIQUE, 
	view text UNIQUE NOT NULL, 
	branch text UNIQUE NOT NULL, 
	/* root text,*/
	project_id integer NOT NULL,
	user text NOT NULL, 
	cspec text NOT NULL,
	icheck integer);

	def _from_row(row)
		@view = row[:view]
		@branch = Confetti.Branch(row[:branch])
		@user = User.new(row[:user])
		@project = Project(row[:project])
		# @root = row[:root]
		
		@view = View(row[:view])
	end

	def is(name, *opt)
		init_flags([:raw], opt)

		@name = name
		raise "invalid name" if !@name
		
		row = db.single("select name, view, branch, root, user, project from activities where name='#{@name}'")
		fail "Unknown activity: #{@name}" if row == nil
		_from_row(row)
	end

	def create(name, *opt, project: nil, )
		init_flags([:raw], opt)
		init([:name], [:user, :branch, :view, :project, :root], [:raw, :jazz], opt)
		raise "invalid name" if !@name

		@user = System.user if !@raw
		@name = "#{@user}_#{@name}" if !@raw
		@name += "_" + Bento.rand_name if @jazz
		@branch = "#{@name}_br"  if !@branch
		@view = "#{@name}" if !@view
		@project = "main" if !@project
		@root = '' if !@root
		@last_check = 0

		raise "create activity #{@name} failed: already exists" if exists?

		br_args = {name: @branch}
		br_args[:root_vob] = @root if @root
		ClearCASE::Branch.create(br_args)

		view_args = {name: @view}
		view_args[:root_vob] = @root if @root
		ClearCASE::View.create(view_args)

		db.execute("insert into activities (name, view, branch, root, user, project, last_check) " +
			"values ('#{@name}', '#{@view}', '#{@branch}', '#{@root}', '#{@user}', '#{@project}', #{@last_check})")
	end
	

	def Activity.create(*opt)
		Activity.new(opt, :create)
	end

	#------------------------------------------------------------------------------------------

	def exists?
		db.get_first_value("select count(*) from activities where name='#{name}'") == 1
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

	private :is, :from_file
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
