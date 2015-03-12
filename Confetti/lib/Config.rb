
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Config

	@@testenv = nil
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
	# (ii)  CONFETTI_TEST env var => TestEnv(CONFETTI_TEST)
	# (iii) test=`cat tests/.test` => TestEnv(test)
	# (iv)  new TestEnv

	def Config.data_path
		return @@pending_data_path if @@pending_data_path

		data = ENV["CONFETTI_DATA"]
		if !data
			if !@@testenv
				begin
					@@testenv = Confetti.TestEnv()
				rescue
					@@testenv = Confetti::TestEnv.create() #make_vob: false)
					pedning_data_path = nil
				end
			end
			data = @@testenv.data_path
			write_default_testenv
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

	def Config.tests_path
		confetti_path/"tests"
	end

	def Config.test_source_path
		confetti_path/"test"
	end
	
	#------------------------------------------------------------------------------------------
	# TestEnv (Box)
	#------------------------------------------------------------------------------------------

	def Config.is_in_testenv?
		!ENV["CONFETTI_DATA"]
	end

	def Config.testenv
		return nil if !is_in_testenv?
		@@testenv
	end

	def Config.testenv_name
		name = ENV["CONFETTI_TEST"]
		return name if name
		fname = Config.default_testenv_filename
		name = File.read(fname) if File.exists?(fname)
		name
	end

	def Config.default_testenv_filename
		Config.tests_path/".test"
	end
	
	def Config.write_default_testenv
		ENV["CONFETTI_TEST"] = @@testenv.id
		IO.write(Config.default_testenv_filename, @@testenv.id)
	end

	def self.remove_default_testenv
		ENV["CONFETTI_TEST"] = nil
		File.delete(Config.default_testenv_filename) rescue ''
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
		@@root_vob = @@testenv.root_vob if @@testenv
		if !@@root_vob
			vob_name = ENV["CONFETTI_ROOT_VOB"]
			@@root_vob = ClearCASE.VOB(vob_name) if !!vob_name
		end
		@@root_vob
	end

end # Config

#----------------------------------------------------------------------------------------------

end # module Confetti
