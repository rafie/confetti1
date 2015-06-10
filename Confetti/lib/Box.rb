
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
	def create(*opt, make_fs: true, make_vob: true, fs_source: 'new/fs/', vob_zip: 'new/test.vob.zip')
		init_flags([:nopush], opt)

		@id = Box.make_id
		@root = root_path
		Config.pending_data_path = @root

		raise "Box @id exists: aborting" if File.exists?(@root)
		FileUtils.mkdir_p(@root)

		@fs_source = Config.test_source_path/fs_source
		create_fs if make_fs

		create_db

		stage = :postvob

		@vob_zip = Config.test_source_path/vob_zip
		create_vob if make_vob

		@views = Views.new

		write_cfg
		Config.set_box(self)
		
		rescue => x
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
		if File.directory?(@fs_source)
			FileUtils.cp_r(Dir.glob(@fs_source/"*"), @root)
		elsif File.file?(@fs_source)
			Bento.unzip(@fs_source, @root)
		end
	end

	#------------------------------------------------------------------------------------------

	def create_vob
		@root_vob = ClearCASE::VOB.create('', file: @vob_zip)
		ENV["CONFETTI_ROOT_VOB"] = @root_vob.name
		write_cfg
	end

	#------------------------------------------------------------------------------------------

	def create_db
		Confetti::Database.connect
#		ActiveRecord::Base.connection.execute("INSERT INTO 'projects' (id, name, branch) VALUES(3, 'mcu-8.3',  'mcu-8.3_int');")
#		ActiveRecord::Base.connection.execute(File.read(Config.test_source_path/"db/data.sql"))
		Bento.DB(path: Config.db_path) << File.read(Config.test_source_path/"db/data.sql")
	end

	#------------------------------------------------------------------------------------------

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
end

#----------------------------------------------------------------------------------------------

end # module Confetti
