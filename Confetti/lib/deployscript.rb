require 'json'
require_relative 'deploy.rb'
module Confetti
conf=File.read("../../../confetti1/Confetti/lib/config.json")
my_hash = JSON.parse(conf)
fold = my_hash["ProdFolder"]
repo = my_hash["SourceRepo"]
tag = my_hash["Tag"]
repos = my_hash["Repositories"]
migrationScript = my_hash["MigrationScript"]
deploymentBranch = my_hash["DeploymentBranch"]
dep=Deployment.new(repo,fold,tag,repos,migrationScript,deploymentBranch)
dep.commitAndPush
dep.lockDBProd
dep.deployProd
dep.migrateDB
dep.unlockDBProd
end