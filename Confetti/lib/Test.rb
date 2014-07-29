
require 'byebug'
require 'Bento/lib/Test'
require 'Confetti/lib/Confetti.rb'

module Confetti

TEST_MODE = true

#----------------------------------------------------------------------------------------------

class Test < Bento::Test
	attr_reader :path, :root_vob

	def _before
		super(false)

		begin
			if create_fs?
				@@root = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S")
				while File.directory?(@@root)
					@@root = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S%L")
				end
				FileUtils.mkdir_p(@@root)
				Bento.unzip(fs_zip, @@root)
			end

			if create_vob? && TEST_WITH_CLEARCASE
				@@root_vob = ClearCASE::VOB.create('', file: vob_zip)
			end

			before
		rescue => x
		end
	end

	def _after
		super(false)
		after rescue ''
		cleanup rescue ''
		after_cleanup rescue ''
	end

	def setup
		super()
	end

	def teardown
	end

	#------------------------------------------------------------------------------------------	

	def cleanup
		if !keep?
			if create_fs?
				Confetti::DB.cleanup rescue ''
				FileUtils.rm_r(@@root) rescue ''
			end
			if create_vob?
				@@root_vob.remove! rescue ''
			end
		end
		# @@root_vob = nil
		# @@root = nil
	end

	def after_cleanup; end

	#------------------------------------------------------------------------------------------	

	def keep?
		false
	end

	def create_fs?
		true
	end

	def create_vob?
		false
	end

	def fs_zip
		'test.fs.zip'
	end

	def vob_zip
		'test.vob.zip'
	end

	#------------------------------------------------------------------------------------------	

	def root
		@@root
	end

	def root_vob
		@@root_vob
	end

	def self.root
		@@root
	end
	
	def self.root_vob
		@@root_vob
	end

	def self.current
		@@test_object
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
