require 'commander/import'
require 'json'
require_relative 'deploy.rb'

module Confetti

program :name, "deploy"
program :version, '1.0'
program :description, 'confetti auto deployment'

command :auto do |c|
	conf=File.read("../../../confetti1/Confetti/lib/config.json")
	my_hash = JSON.parse(conf)
	fold = my_hash["ProdFolder"]
	repo = my_hash["SourceRepo"]
	tag = my_hash["Tag"]
	repos = my_hash["Repositories"]
	migrationScript = my_hash["MigrationScript"]
	deploymentBranch = my_hash["DeploymentBranch"]
	say 'Parameters loaded'
	dep=Deployment.new(repo,fold,tag,repos,migrationScript,deploymentBranch)
	say 'commit and push'
	dep.commitAndPush
	say 'production environment locked'
	dep.lockDBProd
	say 'deploying'
	dep.deployProd
	say 'migrating DB'
	#dep.migrateDB
	say 'unlocking production environment'
	dep.unlockDBProd	
end
end