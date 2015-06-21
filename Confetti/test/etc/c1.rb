
require 'byebug'
require 'yaml'
require 'Bento'

module Confetti1
module Import

$bb=true

#	def Import::ConfigSpec(*args)
#		x = Import::ConfigSpec.send(:new)
#		x.send(:is, *args)
#		x
#	end

class ConfigSpec
	include Bento::Class

	Confetti1::Import.class_eval(<<END)
		def Import::ConfigSpec(*args)
			x = Import::ConfigSpec.send(:new)
			x.send(:is, *args)
			x
		end
END

	constructors :is
#	members :cspecfile, :vobs_arr, :view_name
	
	def is(cspecfile)
		@cspecfile = cspecfile
#		out = File.read(cspecfile).split("/element \/|element \\/")
#		@vobs_arr = Array.new(out.length)
#		out.shift
#		out.each_with_index { |val, index| @@vobs_arr[index]=val.squeeze(" ").split(" ")[1] }
#		@@vobs_arr.reject!(&:nil?).reject!(&:empty?)
	end
	
	def vobs
#		@vobs_arr
	end
	
	def applyToView(viewName)
#		Dir.chdir("M:/#{viewName}") do
#			system("cleartool setcs #{@cspecfile}")
#		end
	end
	
	def migrate(repo)
#		@vobs.each do |vob|
#			repo.add("m:/#{@view_name}/#{vob}")
#			# git --git-dir=d:\view\.git --work-tree=m:\view
#		end
#		repo.commit("migrated from clearcase")
	end
end

end # Import
end # Confetti

bb
x = Confetti1::Import.ConfigSpec('sdf')
bb
puts x
