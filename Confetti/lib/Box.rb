
require_relative 'Common'
require_relative 'Config'
require 'Bento/lib/Test'

module Confetti

#----------------------------------------------------------------------------------------------

class Box
	include Bento::Class

	constructors :is, :create
	members :id, :root, :root_vob, :fs_source, :vob_zip, :views

	attr_reader :id, :root, :root_vob, :views

	#------------------------------------------------------------------------------------------

	def is(id = nil)
		if !id
			id = Config.box_name
			raise "Box: cannot determine test ID" if !id
		end

		@id = id
		@root = root_path
		json = JSON.parse(File.read(@root/'test.json'))

		vob_name = json['vob'].to_s
		@root_vob = ClearCASE.VOB(vob_name) if !vob_name.empty?

		@views = []
		for view in json['views']
			@views << ClearCASE.View(view)
			# ClearCASE.View(view).start
		end
	end

	#------------------------------------------------------------------------------------------

	# opt: :keep
	def create(*opt, make_fs: true, make_vob: true, fs_source: 'new/fs/', vob_zip: 'new/test.vob.zip')
		init_flags([], opt)

		@id = Box.make_id
		@root = root_path
		Config.pending_data_path = @root

		raise "Box @id exists: aborting" if File.exists?(@root)
		FileUtils.mkdir_p(@root)

		@fs_source = Config.test_source_path/fs_source
		create_fs if make_fs

		create_db

		@vob_zip = Config.test_source_path/vob_zip
		create_vob if make_vob

		@views = []

		write_cfg
	end

	#------------------------------------------------------------------------------------------

	def vob_name
		@root_vob ? @root_vob.name : ""
	end

	#------------------------------------------------------------------------------------------

	def root_path
		Config.tests_path/@id
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
		while File.directory?(Config.tests_path/id)
			id = Time.now.strftime("%y%m%d-%H%M%S%L")
		end
		id
	end

	#------------------------------------------------------------------------------------------

	def write_cfg
		File.write(@root/"test.json", JSON.generate({ :views => @views, :vob => vob_name }))
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
		Bento::DB.create(path: Config.db_path, data: Config.test_source_path/"db/data.sql")
	end

	#------------------------------------------------------------------------------------------

	def add_view(view)
		@views << view.name
		write_cfg
	end

	def remove_view(view)
		@views.delete(view.name)
		write_cfg
	end

	def remove_view!(view)
		name = view.name
		view.remove!
		@views.delete(name)
		write_cfg
	end

	#------------------------------------------------------------------------------------------
	# Removal
	#------------------------------------------------------------------------------------------

	def remove!
		abort = false
		failed_objects = []

		begin
			FileUtils.rm_r(@root)
		rescue
		end

		while ! @views.empty? do
			view = @views.first
			begin
				view.remove!
				views.shift
				write_cfg
			rescue
				failed_objects << "view #{view}"
				abort = true
			end
		end
		raise 

		@root_vob.remove! if @root_vob
		@root_vob = nil
		write_cfg

		Config.remove_default_box
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
