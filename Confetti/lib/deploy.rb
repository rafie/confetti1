require 'rubygems'
require 'git'
#-----------------------------------------------------------------------------
#             target local referential
#-----------------------------------------------------------------------------
g=Git.open(".")
#-----------------------------------------------------------------------------
#             add a db migration script
#-----------------------------------------------------------------------------
g.add('confetti\\lib\\dbmigration1.rb')
#-----------------------------------------------------------------------------
#             commit and push changes
#-----------------------------------------------------------------------------
begin
g.tag("1.0.1")
g.commit("CMSG")
rescue
puts("nothing to commit") 
end
g.push
#-----------------------------------------------------------------------------
#           create a file to isolate production db
#-----------------------------------------------------------------------------
File.new("c:\\proddropfolder\\dblock.cft", "w")


#-----------------------------------------------------------------------------
#           create the batch file that imports source 
#           code from github to production. Execution of batch
#-----------------------------------------------------------------------------
out_file = File.new("c:\\proddropfolder\\getconfetti.bat", "w")
out_file.puts("git clone https://github.com/rafie/confetti1 c:\\proddropfolder\\confetti1")
out_file.close
system("pushd c:\\proddropfolder\\")
system("c:\\proddropfolder\\getconfetti.bat")

#-----------------------------------------------------------------------------
#         execution of the db migration script that has been added
#-----------------------------------------------------------------------------
system("ruby", "c:\\proddropfolder\\confetti1\\confetti\\lib\\dbmigration1.rb")

#-----------------------------------------------------------------------------
#         production lock release
#-----------------------------------------------------------------------------
File.delete("c:\\proddropfolder\\dblock.cft")
