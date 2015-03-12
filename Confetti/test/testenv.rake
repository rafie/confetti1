
require_relative '../lib/TestEnv.rb'

namespace :env do

#----------------------------------------------------------------------------------------------

task :status do
	env = nil
	begin
		env = Confetti.TestEnv()
		puts "name: " + env.id
	rescue
		puts "no env"
		return
	end
	puts "views: " + env.views.map {|v| v.name }.to_s
	puts "vob: " + env.vob_name.to_s
end

#----------------------------------------------------------------------------------------------

task :new do
	env = Confetti::TestEnv.create()
	puts "Created enrironment #{env.id}"
end

#----------------------------------------------------------------------------------------------

task :rm do
	name = ENV["NAME"]
	env = Confetti.TestEnv(name.to_s.empty? ? nil : name)
	env.remove!
	puts "Environment #{env.id} removed."
end

#----------------------------------------------------------------------------------------------

task :set do
end

#----------------------------------------------------------------------------------------------

task :pack do
end

#----------------------------------------------------------------------------------------------

task :unpack do
end

#----------------------------------------------------------------------------------------------

end # namespace env
