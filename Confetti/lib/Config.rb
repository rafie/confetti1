
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Config

	@@box = nil
	@@pending_data_path = nil
	@@root_vob = nil

	def Config.root_path
		root = ENV["CONFETTI_ROOT"]
		root = File.expand_path("../../../..", __FILE__) if !root
		Pathname.new(root)
	end

	def Config.confetti_path
		root_path/"confetti1/Confetti"
	end

	#------------------------------------------------------------------------------------------
	# Data
	#------------------------------------------------------------------------------------------

	# Data path determination process:
	# (i)   CONFETTI_DATA env var
	# (ii)  CONFETTI_BOX env var => Box(CONFETTI_BOX)
	# (iii) box=`cat boxes/.box` => Box(box)
	# (iv)  new Box

	def Config.data_path
		return @@pending_data_path if @@pending_data_path

		data = ENV["CONFETTI_DATA"]
		if !data
			if !@@box
				begin
					@@box = Confetti.Box()
				rescue
					@@box = Confetti::Box.create() #make_vob: false)
				end
				pedning_data_path = nil
			end
			data = @@box.data_path
			write_default_box
		end
		Pathname.new(data)
	end

	def Config.pending_data_path=(path)
		@@pending_data_path = path
	end

	def Config.db_path
		Config.data_path/"db/confetti.db"
	end

	#------------------------------------------------------------------------------------------
	# Tests
	#------------------------------------------------------------------------------------------

	def Config.test_source_path
		confetti_path/"test"
	end

	#------------------------------------------------------------------------------------------
	# Boxes
	#------------------------------------------------------------------------------------------

	def Config.boxes_path
		confetti_path/"boxes"
	end

	def Config.default_box_filename
		Config.boxes_path/".box"
	end

	def Config.inside_the_box?
		!ENV["CONFETTI_DATA"]
	end

	def Config.box
		return nil if !inside_the_box?
		if @@box == nil
			name = Config.box_name
			@@box = Confetti.Box(name) if name
		end
		@@box
	end

	def Config.set_box(box)
		@@box = box
		write_default_box
	end

	def Config.box_name
		name = ENV["CONFETTI_BOX"]
		return name if name
		fname = Config.default_box_filename
		name = File.read(fname) if File.exists?(fname)
		name
	end

	def Config.write_default_box
		ENV["CONFETTI_BOX"] = @@box.id
		IO.write(Config.default_box_filename, @@box.id)
	end

	def self.remove_box(name)
		remove_default_box if name == Config.box_name
	end

	def self.remove_default_box
		ENV["CONFETTI_BOX"] = nil
		File.delete(Config.default_box_filename) rescue ''
	end

	#------------------------------------------------------------------------------------------
	# In view
	#------------------------------------------------------------------------------------------

	def Config.config_path_in_view(view = nil)
		view = Confetti.CurrentView() if !view
		raise "Config: cannot determine view" if !view
		view.path + "/nbu.meta/confetti"
	end

	#------------------------------------------------------------------------------------------
	# ClearCase
	#------------------------------------------------------------------------------------------

	def Config.root_vob
		return @@root_vob if @@root_vob
		@@root_vob = @@box.root_vob if @@box
		if !@@root_vob
			vob_name = ENV["CONFETTI_ROOT_VOB"]
			@@root_vob = ClearCASE.VOB(vob_name) if !!vob_name
		end
		@@root_vob
	end

end # Config

#----------------------------------------------------------------------------------------------

end # module Confetti
