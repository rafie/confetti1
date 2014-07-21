
require 'minitest'
require 'Confetti/lib/Confetti.rb'

module Confetti

TEST_MODE = true

#----------------------------------------------------------------------------------------------

class Test < MiniTest::Test
	attr_reader :path, :root_vob

	def initialize(name)
		if create_fs?
			@path = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S")
			while File.directory?(path)
				@path = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S%L")
			end
			FileUtils.mkdir_p(@path)
			Bento.unzip(fs_zip, @path)
		end

		if create_vob? && TEST_WITH_CLEARCASE
			@root_vob = ClearCASE::VOB.create('', file: vob_zip)
		end

		super(name)
		
		@@current_test = self
	end

	def teardown
		cleanup
	end

	def cleanup
		@@current_test = nil

		return if keep?
		if create_fs?
			Confetti::DB.cleanup
			FileUtils.rm_r(@path) rescue ''
		end
		if create_vob?
			@root_vob.remove!
		end
	end

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
		@path
	end
	
	def root_vob
		@root_vob
	end

	def Test.current
		@@current_test
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
