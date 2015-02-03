require 'json'
require_relative 'deploy.rb'
module Confetti
conf=File.read("../../../confetti1/Confetti/lib/config.json")
my_hash = JSON.parse(conf)
fold = my_hash["ProdFolder"]
repo = my_hash["SourceRepo"]
dep=Deployment.new(repo,fold)
#dep.addNewFiles("confetti/lib/config.json,confetti/lib/deployscript.rb")
dep.commitAndPush("0.0.4","first run","didier")
dep.lockDBProd
dep.deployProd("0.0.3")
dep.migrateDB("dbmigration1.rb")
dep.unlockDBProd
end