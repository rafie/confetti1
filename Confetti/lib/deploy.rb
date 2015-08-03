<<<<<<< HEAD
require 'rubygems'
require 'Bento'
=======
>>>>>>> ba7ea67e83986d139bbadbd62b9c8b649fb74d2a

require 'Bento'

module Confetti

class Deployment

<<<<<<< HEAD

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
		f=File.new($prodDropFolder + "/" + LOCKFILENAME,'w')
		f.close
		return 0
=======
	LOCKFILENAME = "dblock.cft"

	def initialize(prmSourceRepoURL="https://github.com/rafie", prmProdDropFolder)
		$prodDropFolder = prmProdDropFolder
		$sourceRepoURL = prmSourceRepoURL
>>>>>>> ba7ea67e83986d139bbadbd62b9c8b649fb74d2a
	end

<<<<<<< HEAD
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
=======
	# add a db migration script
	def add_new_files(files)
		array = files.split(/,/)
		array.size.times do |i|
			System.command("git add " + array[i])
		end 
	end

	# commit and push changes
	def commit_and_push(tag, message)
		begin
			System.command("git tag" + tag)
			System.command("git commit -m " + message)
			rescue
				puts("nothing to commit") 
			end
		System.command("git push origin :" + tag )
	end

	# create a file to isolate production db. If it already exists then another 
	# deployment is currently running.
	def lockDBProd
		unless File.exist?($prodDropFolder + "/" + LOCKFILENAME)
			File.new($prodDropFolder + "/" + LOCKFILENAME, "w")
			return false
		end
		return true
	end

	# Creation of directories and pull source code from github to production.
	
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
>>>>>>> ba7ea67e83986d139bbadbd62b9c8b649fb74d2a

	# execution of the db migration script that has been added
	def migrateDB(scriptFileName)
		System.command("ruby", $prodDropFolder + "/confetti1/confetti/lib/" + scriptFileName)
	end

	# production lock release
	def unlockDBProd
		File.delete($prodDropFolder + "/" + LOCKFILENAME)
	end

end # Deployment

end # Confetti
