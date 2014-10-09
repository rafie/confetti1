
require_relative 'Confetti'

require_relative 'Project'

module Confetti

#----------------------------------------------------------------------------------------------

class Activity
	include Bento::Class

	constructors :is, :create
	members :id, :name, :view, :branch, :project, :user, :cspec, :icheck
	
	attr_reader :name, :user, :branch, :view

	#------------------------------------------------------------------------------------------

	def is(name, *opt)
		init_flags([:raw], opt)

		raise "invalid name" if !name
		@name = name.to_s
		
		row = db.one("select a.id, a.name, view, a.branch, user, p.name as project, project_id from activities as a join projects as p on p.id = a.project_id where a.name=?", @name)
		fail "Unknown activity: #{@name}" if row == nil
		from_row(row)
	end

	def create(name, *opt, project: nil)
		init_flags([:raw], opt)

		@name = name
		raise "invalid name" if !@name
		raise "create activity #{@name} failed: already exists" if exists?

		raise "invalid project" if !project

		@user = System.user.downcase if !@raw
		@name = "#{@user}_#{@name}" if !@raw
		@branch = Confetti::Branch.create(@name, :raw)
		@project = project
		@icheck = 0

		@cspec = project.cspec
		@cspec.tag = @name
		@view = Confetti::View.create(@name, :raw, cspec: @cspec)

		@id = db.insert(:activities, %w(name view branch project_id user cspec icheck),
			@name, @view.name, @branch.name, @project.id, @user, '', @icheck)
	end
	
	def from_row(row)
		@id = row[:id]
		@view = Confetti.View(row[:view])
		@branch = Confetti.Branch(row[:branch])
		@user = User.new(row[:user])
		@project = Project.from_id(row[:project_id])
		@cspec = Confetti.CSpec(row[:cspec])
		@icheck = row[:icheck]
	end

	private :from_row

	#------------------------------------------------------------------------------------------

	def exists?
		db.val("select count(*) from activities where name=?", name) == 1
	end	

	#------------------------------------------------------------------------------------------

	def checkouts
		view.checkouts
	end
	
	def active_elements
		view.on_branch(branch)
	end

	#------------------------------------------------------------------------------------------

	def icheck
		db.get_first_value("select icheck from activities where name='#{@name}'")
	end

	def inc_check
		db.execute("update activities set icheck = icheck + 1 where name='#{@name}'")
		icheck
	end

	def icheck_name
		Activity.check_name(@name, icheck)
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
	
	def db
		Confetti::DB.global
	end

end # Activity

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
