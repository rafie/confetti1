require 'rubygems'
require 'Bento'


module Confetti


class Deployment


LOCKFILENAME="dblock.cft"

def initialize(prmSourceRepoURL,prmProdDropFolder,prmTag,prmRepositories,prmMigrationScript,prmDeploymentBranch)
		$prodDropFolder=prmProdDropFolder
		$sourceRepoURL=prmSourceRepoURL
		$tag=prmTag
		$repositories=prmRepositories
		$migrationScript=prmMigrationScript
		$deploymentBranch=prmDeploymentBranch
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
def commitAndPush
	$repositories.size.times do |i|
		Dir.chdir("../../../" + $repositories[i]) do
			begin
				System.command("git tag " + $tag)
				System.command('git commit -a -m "auto deploy of tag ' + $tag +  '"')
				rescue
					puts("nothing to commit in " + $repositories[i])  
				end
			System.command("git push origin " + $tag )
			System.command("git push origin " + $deploymentBranch )
		end
	end 
	
	
	
	
	
end
#-----------------------------------------------------------------------------
#           create a file to isolate production db. If it already
#           exists then another deployment is currently running.
#-----------------------------------------------------------------------------
def lockDBProd
	unless File.exist?($prodDropFolder + "/" + LOCKFILENAME)
		File.new($prodDropFolder + "/" + LOCKFILENAME,'w')
		return 0
	end
	return 1
end

#-----------------------------------------------------------------------------
#           Creation of directories and pull source 
#           code from github to production.
#-----------------------------------------------------------------------------

def deployProd
	
	Dir.chdir($prodDropFolder) do
		$repositories.size.times do |i|
			unless Dir.exist?($prodDropFolder + "/" + $repositories[i])
				System.command("git clone " + $sourceRepoURL + "/" + $repositories[i] + " -b " + $tag)
			else
				Dir.chdir($prodDropFolder + "/" + $repositories[i]) do
					System.command("git rebase " + $tag)
				end
			end
		end
	end
	
	#System.command("git checkout " + tag)
end

#-----------------------------------------------------------------------------
#         execution of the db migration script that has been added
#-----------------------------------------------------------------------------
def migrateDB
	#System.command($prodDropFolder + "/classico1-ruby/Ruby/bin/ruby", $prodDropFolder + "/confetti1/confetti/lib/" + $migrationScript)
	system($prodDropFolder + "/classico1-ruby/Ruby/bin/RUBY", "-r",$prodDropFolder + "/confetti1/confetti/lib/" + $migrationScript)
end
#-----------------------------------------------------------------------------
#         production lock release
#-----------------------------------------------------------------------------
def unlockDBProd
	Dir.chdir($prodDropFolder) do
		System.command('del ' + LOCKFILENAME)
	end
end


end  #module


end #class  