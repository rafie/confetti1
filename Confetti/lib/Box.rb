
require_relative 'Common'
require_relative 'Config'
require_relative 'Database'

require 'Bento/lib/Test'

module Confetti

#----------------------------------------------------------------------------------------------

class Box
	include Bento::Class

	constructors :is, :create
	members :id, :root, :root_vob, :fs_source, :vob_zip, :views

	attr_reader :id, :root, :root_vob, :views

	#------------------------------------------------------------------------------------------

	def is(id = nil, *opt)
		init_flags([], opt)

		if !id
			id = Config.box_name
			raise "Box: cannot determine test ID" if !id
		end

		@id = id
		@root = root_path
		Config.pending_data_path = @root

		json = JSON.parse(File.read(@root/'box.json'))
		
		vob_name = json['vob'].to_s
		@root_vob = ClearCASE.VOB(vob_name) if !vob_name.empty?

		@views = Views.new(json['views'])
	end

	#------------------------------------------------------------------------------------------

	# opt: :keep
	def create(*opt, source: 'box', make_fs: true, make_vob: true)
		init_flags([:nopush], opt)

		@id = Box.make_id
		@root = root_path
		Config.pending_data_path = @root

		raise "Box @id exists: aborting" if File.exists?(@root)
		FileUtils.mkdir_p(@root)

		@fs_source = Config.test_source_path/source/"fs"
		create_fs if make_fs

		create_db

		# stage = :postvob

		@views = Views.new
		write_cfg

		@vob_zip = Config.test_source_path/source/"vob.zip"
		create_vob if make_vob
		write_cfg

		Config.set_box(self)
		
		rescue => x
			error x.to_s
			puts x.backtrace.join("\n")
			# exception x, "Box: creation failed"
			remove!
			raise "Box: creation failed"
	end

	#------------------------------------------------------------------------------------------

	def name
		id
	end

	def vob_name
		@root_vob ? @root_vob.name : ""
	end

	#------------------------------------------------------------------------------------------

	def root_path
		Config.boxes_path/@id
	end

	#------------------------------------------------------------------------------------------

	def data_path
		root_path
	end

	def db_path
		root_path/"db/confetti.db"
	end
		
	#------------------------------------------------------------------------------------------

	def self.make_id
		id = Time.now.strftime("%y%m%d-%H%M%S")
		while File.directory?(Config.boxes_path/id)
			id = Time.now.strftime("%y%m%d-%H%M%S%L")
		end
		id
	end

	#------------------------------------------------------------------------------------------

	def write_cfg
		File.write(@root/"box.json", JSON.generate({ :views => @views.names, :vob => vob_name }))
	end

	#------------------------------------------------------------------------------------------
	# Construction
	#------------------------------------------------------------------------------------------

	def create_fs
		# this is required to create empty directories, which git ignores
		zip = @fs_source + ".zip"
		Bento.unzip(zip, @root) if File.file?(zip)
		
		# copy content of fs_source, not fs_source itself
		FileUtils.cp_r(@fs_source/"."), @root) if File.directory?(@fs_source)
		# FileUtils.cp_r(Dir.glob(@fs_source/"*"), @root) if File.directory?(@fs_source)
	end

	#------------------------------------------------------------------------------------------

	def create_vob
		return if !File.exists?(@vob_zip)
		@root_vob = ClearCASE::VOB.create('', file: @vob_zip)
		ENV["CONFETTI_ROOT_VOB"] = @root_vob.name
		write_cfg
	end

	#------------------------------------------------------------------------------------------

	def create_db
		Confetti::Database.create
		scripts = Config.test_source_path/"db/data.sql"
		Confetti::Database.execute_script(script) if File.exists?(script)
	end

	#------------------------------------------------------------------------------------------

	def view_names
		@views == nil ? [] : @views.names
	end

	def add_view(view)
		@views << view
		write_cfg
	end

	def remove_view(view)
		@views.delete(view)
		write_cfg
	end

	def remove_view!(view)
		name = view.name
		view.remove!
		@views.delete(name)
		write_cfg
	end

	#------------------------------------------------------------------------------------------
	# Open/close
	#------------------------------------------------------------------------------------------

	def open
		if @root_vob
			@root_vob.mount if !@root_vob.mounted?
		end

		@views.each do |v|
			v.start rescue ''
		end
	end

	def close
		@views.each do |v|
			v.stop rescue ''
		end

		if @root_vob
			@root_vob.unmount if !@root_vob.mounted?
		end
	end

	#------------------------------------------------------------------------------------------
	# Removal
	#------------------------------------------------------------------------------------------

	def remove!
		bb
		abort = false
		failed_objects = []

		while ! @views.empty? do
			view = @views.first
			begin
				view.remove!
				@views.shift
				write_cfg
			rescue
				failed_objects << "view #{view}"
				abort = true
			end
		end
		raise "box #{id} was not removed: #{failed_objects}" if abort

		@root_vob.remove! if @root_vob
		@root_vob = nil
		write_cfg

		begin
			FileUtils.rm_r(@root)
		rescue
			failed_objects << "directory #{@root}"
		end

		Config.remove_box(id)
	end

end # class Box

#----------------------------------------------------------------------------------------------

class Boxes
	include Enumerable

	def initialize
		@names = Dir[Config.boxes_path/'*'].select {|f| File.directory?(f)}.map {|f| File.basename(f)}
	end

	def each
		@names.each { |name| yield Confetti.Box(name) }
	end

	def print
		default_box = Config.box
		default_name = default_box ? default_box.name : ""
		each do |box|
			name = box.name
			puts name + (default_name == name ? " *" : "")
		end
	end
	
	def self.print
		Boxes.new.print
	end

end # class Boxes

#----------------------------------------------------------------------------------------------

end # module Confetti
