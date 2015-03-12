
require_relative 'Common'
require_relative 'Config'
require 'Bento/lib/Test'

module Confetti

#----------------------------------------------------------------------------------------------

class TestEnv
	include Bento::Class

	constructors :is, :create
	members :id, :root, :root_vob, :fs_source, :vob_zip, :views

	attr_reader :id, :root, :root_vob, :views

	#------------------------------------------------------------------------------------------

	def is(id = nil)
		if !id
			id = Config.testenv_name
			raise "TestEnv: cannot determine test ID" if !id
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
	def create(*opt, make_fs: true, make_vob: true, fs_source: 'fs/', vob_zip: 'test.vob.zip')
		
		@id = TestEnv.make_id
		@root = root_path
		Config.pending_data_path = @root

		raise "TestEnv @id exists: aborting" if File.exists?(@root)
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

	#------------------------------------------------------------------------------------------
	# Removal
	#------------------------------------------------------------------------------------------

	def remove!
#			if create_fs?
#				live_to_tell { Confetti::DB.cleanup }
#				live_to_tell {  }
#			end
		begin
			FileUtils.rm_r(@root)
		rescue
		end

		@views.each { |view| view.remove! }
		@root_vob.remove! if @root_vob

		Config.remove_default_testenv
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
