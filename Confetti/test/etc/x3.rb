
require 'Bento'
require 'Confetti'
require 'byebug'

module Confetti
TEST_MODE=true
end

# cview = Confetti::ProjectControlView.new('test1', project_name: 'project1', branch: 'branch1')
# puts cview.name

baseline_cspec = Confetti::CSpec.from_file('project1-test2.cspec')
lspec = Confetti::LSpec.from_file('project1-test2.lspec')
config = Confetti::ProjectConfig.create('test1', branch: Confetti.Branch('test1_int'), baseline_cspec: baseline_cspec, lspec: lspec)
byebug
config.write('1')
a = 1