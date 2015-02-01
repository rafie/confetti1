require 'rubygems'


module Confetti


class deployment

	include  Bento::System

def initialize(prmProdDropFolder)
		$prodDropFolder=prmProdDropFolder
end
#-----------------------------------------------------------------------------
#             target local referential
#-----------------------------------------------------------------------------
#g=Git.open(".")
#-----------------------------------------------------------------------------
#             add a db migration script
#-----------------------------------------------------------------------------
#g.add('confetti\\lib\\dbmigration1.rb')
def addNewFiles(filesList)
	array = filesList.split(/,/)
	array.size.times do |i|
	  System.command ("git add " + array[i])
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
#           create a file to isolate production db
#-----------------------------------------------------------------------------
def lockDBProd
File.new($prodDropFolder + "\\dblock.cft", "w")
end

#-----------------------------------------------------------------------------
#           create the batch file that imports source 
#           code from github to production. Execution of batch
#-----------------------------------------------------------------------------

def deployProd(tag)
System.command("git clone https://github.com/rafie/confetti1" + $prodDropFolder +"\\confetti1")
System.command("git clone https://github.com/rafie/confetti1-import" + $prodDropFolder +"\\confetti1")
System.command("git clone https://github.com/rafie/classico1-bento" + $prodDropFolder +"\\confetti1")
System.command("git clone https://github.com/rafie/classico1-ruby" + $prodDropFolder +"\\confetti1")
System.command("git checkout " + tag)
end

#-----------------------------------------------------------------------------
#         execution of the db migration script that has been added
#-----------------------------------------------------------------------------
def migrateDB(scriptFileName)
System.command("ruby", $prodDropFolder + "\\confetti1\\confetti\\lib\\" + scriptFileName)
end
#-----------------------------------------------------------------------------
#         production lock release
#-----------------------------------------------------------------------------
def unlockDBProd
File.delete($prodDropFolder + "\\dblock.cft")
end
end  #module


end #class  