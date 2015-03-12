
require_relative 'Confetti'

require_relative 'Project'

module Confetti

#----------------------------------------------------------------------------------------------

module DB

class Activity < ActiveRecord::Base
	has_one :view
end

end # module DB

#----------------------------------------------------------------------------------------------

class Activity
	include Bento::Class

	constructors :is, :create
	members :id, :name, :view, :branch, :project, :user, :cspec, :icheck
	
	attr_reader :name, :user, :branch, :view, :cspec, :project

	#------------------------------------------------------------------------------------------

	def is(name, *opt)
		init_flags([:raw], opt)

		raise "invalid name" if !name
		@name = name.to_s
		
#		row = db.one("select a.id, a.name, view, a.branch, user, p.name as project, project_id from activities as a join projects as p on p.id = a.project_id where a.name=?", @name)
		row = DB::Activity.find_by(name: @name)
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

#		@id = db.insert(:activities, %w(name view branch project_id user cspec icheck),
#			@name, @view.name, @branch.name, @project.id, @user, @cspec.text, @icheck)

		row = DB::Activity.new do |r|
			r.name = @name
			r.view = @view.name
			r.branch = @branch.name
			r.project_id = @project.id
			r.user = @user.to_s
			r.cspec = @cspec.to_s
			r.icheck = @icheck
		end
		row.save

		rescue
			raise "Activity: failed to add check with name='#{@name}' (already exists?)"
	end
	
	def from_row(row)
		fail "Activity: invalid row (name='#{@name}')" if row == nil
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

	def self.exists?(name)
#		Confetti::DB.global.val("select count(*) from activities where name=?", name) == 1
		DB::Activity.find_by(name: @name) != nil
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
		row = DB::Activity.find_by(name: @name)
		row.icheck
#		db.val("select icheck from activities where name=?", @name)
	end

	def inc_check
		row = DB::Activity.find_by(name: @name)
		n = row.icheck + 1
		row.update(icheck: n)
		n
#		db.execute("update activities set icheck = icheck + 1 where name=?", @name)
#		icheck
	end

	def icheck_name
		Activity.check_name(@name, icheck)
	end

	def new_check_name
		Activity.check_name(@name, inc_check)
	end

	def self.check_name(name, check)
		"#{name}_check_#{check}"
	end

	# opt: :keepco
	def check!(*opt, lot: nil)
		keepco = opt.include?(:keepco)
		lot = lot.is_a?(String) ? Confetti.Lot(lot) : lot

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
		cspec1 = cspec.clone
		cspec1.add_check(check_name)
		Confetti.Check.create(check_name, cspec: cspec1)
	end	

	#------------------------------------------------------------------------------------------
	
#	def db
#		Confetti::DB.global
#	end

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
