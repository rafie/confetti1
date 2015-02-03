require 'rubygems'
require 'Bento'


module Confetti


class Deployment


LOCKFILENAME="dblock.cft"

def initialize(prmSourceRepoURL="https://github.com/rafie",prmProdDropFolder)
		$prodDropFolder=prmProdDropFolder
		$sourceRepoURL=prmSourceRepoURL
		
end

#-----------------------------------------------------------------------------
#             add a db migration script
#-----------------------------------------------------------------------------
def addNewFiles(filesList)
	Dir.chdir("c:/github/confetti1") do
		array = filesList.split(/,/)
		array.size.times do |i|
		  System.command("git add " + array[i])
		end 
	end
end
#-----------------------------------------------------------------------------
#             commit and push changes
#-----------------------------------------------------------------------------
def commitAndPush(tag,message,branch)
	Dir.chdir("c:/github/confetti1") do
		begin
			System.command("git tag " + tag)
			System.command('git commit -a -m "' + message + '"')
			rescue
				puts("nothing to commit") 
			end
		System.command("git push origin " + tag )
		System.command("git push origin " + branch )
	end
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
	
	Dir.chdir($prodDropFolder) do
		System.command("git clone " + $sourceRepoURL + "/confetti1 -b " + tag)
		System.command("git clone " + $sourceRepoURL + "/confetti1-import -b " + tag)
		System.command("git clone " + $sourceRepoURL + "/classico1-bento -b " + tag)
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