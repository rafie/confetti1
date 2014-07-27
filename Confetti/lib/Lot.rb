
require '../lib/Test.rb'

require_relative 'Confetti'

module Confetti

#----------------------------------------------------------------------------------------------

# (lots
#   (lot name
#      (vobs v1..vk)
#      (lots l1..lm)))

# Q: should lot have project/stream association?

class Lot

	attr_reader :name

	def is(name, nexp: nil)
		# raise "Lot #{name} does not exist" unless exists?(name)
		@name = name
		@nexp = nexp
	end

	#-------------------------------------------------------------------------------------------

	def vobs
		names = nexp[:vobs]
		names = !names ? [] : ~names
		return ClearCASE::VOBs.new(names)
	end

	def lots
		names = nexp[:lots]
		names = !names ? [] : ~names
		return Lots.new(names)
	end
	
	# Filter out elements not contained in lot

	def filterElements(elements)
		files = []
		vobs.each do |vob|
			files.merge!(elements.filterByVOB(vob))
		end
		return ClearCASE::Elements.new(files)
	end
	
	def label(name, view: nil)
		raise "unimplemented"
	end

	#-------------------------------------------------------------------------------------------

	def nexp
		return @nexp if @nexp
		lots = All::Lots::nexp
		@nexp = (lots/:lot).select { |lot| lot.cadr.to_s == @name }[0]
		raise "lot #{@name} does not exist" if !@nexp
	end

	#-------------------------------------------------------------------------------------------

	def self.is(*args)
		x = self.new; x.send(:is, *args); x
	end

	private :nexp
	private :is
	private_class_method :new
end # Lot

def self.Lot(*args)
	x = Lot.send(:new); x.send(:is, *args); x
end

#----------------------------------------------------------------------------------------------

class Lots
	include Enumerable

	def initialize(names)
		@names = names
	end

	def each
		@names.each { |name| yield Confetti.Lot(name) }
	end
end

#----------------------------------------------------------------------------------------------

module All

#----------------------------------------------------------------------------------------------

class Lots
	include Enumerable

	def initialize(names: nil, project: nil)
		@nexp = Lots.nexp
		@names = names == nil ? (@nexp[:lots]/:lot).rank1 : names
	end

	def each
		@names.each { |name| yield Confetti.Lot(name, nexp: @nexp[:lots].select { |lot| lot.cadr.to_s == name }) }
		# @nexp["lots/lot/#{@name}"]
	end

	def [](x)
		return @names[x] if x.is_a? Fixnum
		Lot.new(x, nexp: @nexp)
	end

	def Lots.nexp
		Nexp::Nexp.from_file(Config.view_path + '/lots.ne', :single)
	end
end # Lots

#----------------------------------------------------------------------------------------------

end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
