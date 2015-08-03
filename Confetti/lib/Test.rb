
require_relative 'Common'
require_relative 'Box'
require 'Bento/lib/Test'

module Confetti

#----------------------------------------------------------------------------------------------

# For a Confetti test class (a class derived from Confetti::Test), the following holds:
# - setup/teardown behave like regular MiniTest classes (executed before/after each test method)
# - before/after methods are executed before/after all class test methods
#
# Control methods: create_box?, create_fs?, create_vob?, keep?

class Test < Bento::Test
	attr_reader :path, :root_vob

	def _before
		bb
		@box = Confetti::Box.create(make_fs: create_fs?, make_vob: create_vob?) if create_box?
		super(false)
		live_to_tell do
			before
		end
	end

	def _after
		bb
		super(false)
		live_to_tell do
			after
			@box.remove! if @box != nil && !keep?
		end
			
#		live_to_tell { cleanup }
#		live_to_tell { after_cleanup }
	end

	def setup
		super()
	end

	def teardown
	end

	#------------------------------------------------------------------------------------------	

#	def cleanup
#		if !keep?
#			if create_fs?
#				live_to_tell { Confetti::DB.cleanup }
#				live_to_tell { FileUtils.rm_r(@@root) }
#			end
#			if create_vob?
#				live_to_tell { @@root_vob.remove! }
#			end
#		end
#		# @@root_vob = nil
#		# @@root = nil
#	end
#
#	def after_cleanup; end

	#------------------------------------------------------------------------------------------	

	def keep?
		ENV["CONFETTI_TEST_KEEP"].to_i == 1
	end

	def create_box?
		true
	end

	def create_fs?
		true
	end

	def create_vob?
		true
	end

#	def fs_source
#		'fs/'
#	end
#
#	def vob_zip
#		'test.vob.zip'
#	end

	#------------------------------------------------------------------------------------------	

#	def root
#		@@root
#	end
#
#	def root_vob
#		@@root_vob
#	end
#
#	def self.root
#		@@root
#	end
#	
#	def self.root_vob
#		@@root_vob
#	end

	def self.current
		@@test_object
	end
end

#----------------------------------------------------------------------------------------------

end # module Confetti
