require 'rubygems'


module Confetti


class Deployment

include  Bento::System
LOCKFILENAME="dblock.cft"

def initialize(prmSourceRepoURL="https://github.com/rafie",prmProdDropFolder)
		$prodDropFolder=prmProdDropFolder
		$sourceRepoURL=prmSourceRepoURL
end

#-----------------------------------------------------------------------------
#             add a db migration script
#-----------------------------------------------------------------------------
def addNewFiles(filesList)
	array = filesList.split(/,/)
	array.size.times do |i|
	  System.command("git add " + array[i])
	end 
end
#-----------------------------------------------------------------------------
#             commit and push changes
#-----------------------------------------------------------------------------
def commitAndPush(tag,message)
	begin
		System.command("git tag" + tag)
		System.command("git commit -m " + message)
		rescue
			puts("nothing to commit") 
		end
	System.command("git push origin :" + tag )
end
#-----------------------------------------------------------------------------
#           create a file to isolate production db. If it already
#           exists then another deployment is currently running.
#-----------------------------------------------------------------------------
def lockDBProd
	unless File.exist?($prodDropFolder + "/" + LOCKFILENAME)
		File.new($prodDropFolder + "/" + LOCKFILENAME, "w")
		return 0
	end
	return 1
end

#-----------------------------------------------------------------------------
#           Creation of directories and pull source 
#           code from github to production.
#-----------------------------------------------------------------------------

def deployProd(tag)
	unless Dir.exist?($prodDropFolder +"/confetti1")
		Dir.mkdir($prodDropFolder +"/confetti1")
	end
	Dir.chdir($prodDropFolder +"/confetti1") do
		System.command("git clone " + $sourceRepoURL + "/confetti1 -b " + tag)
	end
	unless Dir.exist?($prodDropFolder +"/confetti1-import")
		Dir.mkdir($prodDropFolder +"/confetti1-import")
	end
	Dir.chdir($prodDropFolder +"/confetti1-import") do
		System.command("git clone " + $sourceRepoURL + "/confetti1-import -b " + tag)
	end
	unless Dir.exist?($prodDropFolder +"/classico1-bento")
		Dir.mkdir($prodDropFolder +"/classico1-bento")
	end
	Dir.chdir($prodDropFolder +"/classico1-bento") do
		System.command("git clone " + $sourceRepoURL + "/classico1-bento -b " + tag)
	end
	unless Dir.exist?($prodDropFolder +"/classico1-ruby")
		Dir.mkdir($prodDropFolder +"/classico1-ruby")
	end
	Dir.chdir($prodDropFolder +"/classico1-ruby") do
		System.command("git clone " + $sourceRepoURL + "/classico1-ruby -b " + tag)
	end
	#System.command("git checkout " + tag)
end

#-----------------------------------------------------------------------------
#         execution of the db migration script that has been added
#-----------------------------------------------------------------------------
def migrateDB(scriptFileName)
	System.command("ruby", $prodDropFolder + "/confetti1/confetti/lib/" + scriptFileName)
end
#-----------------------------------------------------------------------------
#         production lock release
#-----------------------------------------------------------------------------
def unlockDBProd
	File.delete($prodDropFolder + "/" + LOCKFILENAME)
end


end  #module


end #class  