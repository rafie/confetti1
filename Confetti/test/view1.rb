
require 'minitest/autorun'
require 'Bento'

# require 'Project.rb'
# require 'ProjectVersion.rb'
require 'View.rb'
require 'Test.rb'

require 'byebug'

#----------------------------------------------------------------------------------------------

class ViewName < Minitest::Test

#	def create_fs?; false; end
#	def create_vob?; false; end

	def setup
		@user = System.user.downcase
	end

	def u(x)
		@user + "_" + x
	end

	def test_1_no_raw
		view = Confetti::View.create('', :nop)
		assert_equal u(view.nick), view.tag
		assert_equal view.name, view.tag
		assert_equal nil, view.root_vob

		assert_raises(RuntimeError) do
			view = Confetti.View('')
		end

		view = Confetti.View('foo')
		assert_equal "foo", view.nick
		assert_equal u("foo"), view.name
		assert_equal u("foo"), view.tag
		assert_equal nil, view.root_vob

		view = ClearCASE.View('foo/.bar')
		assert_equal "foo", view.nick
		assert_equal u("foo/.bar"), view.name
		assert_equal u("foo"), view.tag
		assert_equal ".bar", view.root_vob.name

		view = ClearCASE::View.create('foo/.', :nop)
		assert_equal "foo", view.nick
		assert_match /^(.+)_foo\/\.(.+)/, view.name
		refute_equal view.name, view.tag
		assert_equal u("foo"), view.tag
		assert view.root_vob != nil
		assert_equal view.tag + "/" + view.root_vob.name, view.name

#		assert_raises(RuntimeError) do
#			view = ClearCASE.View('foo/.')
#		end

		view = ClearCASE::View.create('/.', :nop)
		assert_match /^(.+)\/\.(.+)/, view.name
		refute_equal view.tag, u(view.name)
		assert view.root_vob != nil

#		assert_raises(RuntimeError) do
#			view = ClearCASE.View('/.')
#		end
	end

end

#----------------------------------------------------------------------------------------------

# class CreateViewFromVersion < Confetti::Test
# end

#----------------------------------------------------------------------------------------------

# class CreateViewFromCheck < Confetti::Test
# end

#----------------------------------------------------------------------------------------------

# class CreateIntView < Confetti::Test
# end

#----------------------------------------------------------------------------------------------
