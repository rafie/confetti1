
require 'minitest'
require 'Confetti/lib/Confetti.rb'

module Confetti

TEST_MODE = 1
TEST_WITH_CLEARCASE = 0

#----------------------------------------------------------------------------------------------

class Test < MiniTest::Test
	attr_reader :path

	def initialize(name)
		@path = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S")
		while File.directory?(path)
			@path = '.tests/' + Time.now.strftime("%y%m%d-%H%M%S%L")
		end
		FileUtils.mkdir_p(@path)
		Bento.unzip(testzip, @path)

		super(name)
		
		@@current_test = self
	end

	def testzip
		'test.fs.zip'
	end

	def keep?
		false
	end

	def cleanup
		@@current_test = nil

		return if keep?
		FileUtils.rm_r(@path) rescue ''
	end
	
	def teardown
		cleanup
	end

	def root
		@path
	end
	
	def Test.current
		@@current_test
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
