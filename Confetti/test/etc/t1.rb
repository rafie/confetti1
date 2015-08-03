
require 'Confetti/lib/Common.rb'
require 'Confetti/lib/Box.rb'
require 'Confetti/lib/Confetti.rb'
require 'Confetti/lib/Config.rb'
require 'Confetti/lib/Database.rb'
require 'Confetti/lib/Check.rb'
require 'Confetti/lib/CSpec.rb'
require 'Confetti/lib/Project.rb'

bb

b = Confetti.Box()
b.remove!

v = ClearCASE.View(nil, name: "confetti.project_test1", root_vob: ".beguwaba")

v = ClearCASE.View("v1")
v = ClearCASE.View(name: "confetti.project_test1/.beguwaba")
b = Confetti.Branch("test1")
baseline_cspec = Confetti::CSpec.from_file('cspec1-cspec1.cspec')
lspec = Confetti::LSpec.from_file('cspec1-lspec1.lspec')
pc = Confetti::ProjectConfig.create("test1", branch: b, baseline_cspec: baseline_cspec, lspec: lspec)

byebug

p = Confetti::Project.create('test1', 
	baseline_cspec: Confetti::CSpec.from_file('cspec1-cspec1.cspec'), 
	lspec: Confetti::LSpec.from_file('cspec1-lspec1.lspec'))
p1 = Confetti.Project('test1')

puts "done."


# puts "Config.root_path: " + Confetti::Config.root_path
# puts "Config.data_path: " + Confetti::Config.data_path
# puts "Config.db_path: " + Confetti::Config.db_path


# te = Confetti.TestEnv
# te.remove!

# c = Confetti::Check.create("jojo", cspec: Confetti::CSpec.from_file("project1-test2.cspec"))
# c0 = Confetti::Check.create("jojo", cspec: Confetti::CSpec.from_file("project1-test2.cspec"))
# c1 = Confetti.Check("jojo")

# Confetti::Database.migrate
