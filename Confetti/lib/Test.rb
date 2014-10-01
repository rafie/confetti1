
require 'byebug'
require 'Bento/lib/Test'
require 'Confetti/lib/Confetti.rb'

module Confetti

TEST_MODE = true
KEEP_FS = ENV["CONFETTI_TEST_KEEP"].to_i == 1
TEST_WITH_CLEARCASE = ENV["CONFETTI_TEST_CCASE"].to_i == 1

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
				if File.directory?(fs_source)
					FileUtils.cp_r(Dir.glob(fs_source + "/*"), @@root)
				elsif File.file?(fs_source)
					Bento.unzip(fs_source, @@root)
				end
			end

			if create_vob? && TEST_WITH_CLEARCASE
				@@root_vob = ClearCASE::VOB.create('', file: vob_zip)
			end

			before
		rescue => x
			self.failures << Minitest::UnexpectedError.new(x)
		end
	end

	def _after
		super(false)
		live_to_tell { after }
		live_to_tell { cleanup }
		live_to_tell { after_cleanup }
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
				live_to_tell { Confetti::DB.cleanup }
				live_to_tell { FileUtils.rm_r(@@root) }
			end
			if create_vob?
				live_to_tell { @@root_vob.remove! }
			end
		end
		# @@root_vob = nil
		# @@root = nil
	end

	def after_cleanup; end

	#------------------------------------------------------------------------------------------	

	def keep?
		KEEP_FS
	end

	def create_fs?
		true
	end

	def create_vob?
		false
	end

	def fs_source
		'fs/'
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
