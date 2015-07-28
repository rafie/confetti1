
require 'Confetti'
require_relative '../../lib/Production.rb'

bb
# ENV["CONFETTI_DATA"]='../../../prod'
# prod = Confetti.Production()
# ENV["CONFETTI_DATA"]=''
# prod = Confetti::Production.create('../../../prod')

# prod = Confetti.Production('../../../prod')
# prod.release

ws = Confetti.Workspace()
ws.deploy

puts 'done'