
require 'minitest/autorun'
require 'Bento'

# require 'Project.rb'
# require 'ProjectVersion.rb'
require 'Confetti/lib/View.rb'
require 'Confetti/lib/Test.rb'

require 'byebug'

#----------------------------------------------------------------------------------------------

class ViewName < Confetti::Test

#	def create_box?; false; end
#	def create_fs?; false; end
	def create_vob?; false; end

	def setup
		byebug
		super()
	end
		
	def before
		@user = System.user.downcase
	end

	def u(x)
		@user + "_" + x
	end

	def test_1_no_raw
		byebug

		cspec = Confetti.CSpec("(cpsec)")

		view = Confetti::View.create('', cspec: cspec)
		assert_equal u(view.nick), view.name
		assert_equal view.name, view.internal.name

		view = Confetti.View("foo")
		assert_equal "foo", view.nick
		assert_equal u("foo"), view.name
		assert_equal u("foo"), view.internal.name

		view = Confetti.View(nil, name: "foo")
		assert_equal "foo", view.nick
		assert_equal u("foo"), view.name
		assert_equal u("foo"), view.internal.name

		view = Confetti.View('foo/.bar')
		assert_equal "foo", view.nick
		assert_equal u("foo/.bar"), view.name
		assert_equal u("foo"), view.tag
		assert_equal ".bar", view.root_vob.name
	end

end

#----------------------------------------------------------------------------------------------

class CreateViewFromVersion < Confetti::Test

	def test_1
#		view = COnfetti.
	end

end

#----------------------------------------------------------------------------------------------

# class CreateViewFromCheck < Confetti::Test
# end

#----------------------------------------------------------------------------------------------

# class CreateIntView < Confetti::Test
# end

#----------------------------------------------------------------------------------------------
