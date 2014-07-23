
require 'Bento'
require '../lib/View.rb'
require 'byebug'

module Confetti
TEST_MODE=true
end

cview = Confetti::ProjectControlView.new('test1', project_name: 'project1', branch: 'branch1')
puts cview.name
