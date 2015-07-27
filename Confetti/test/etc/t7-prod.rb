
require 'Confetti'
require_relative '../../lib/Production.rb'

bb
ENV["CONFETTI_DATA"]='../../../prod'
prod = Confetti.Production()
ENV["CONFETTI_DATA"]=''
prod = Confetti.Production('../../../prod')
prod = Confetti::Production.create('../../../prod')
puts 'done'