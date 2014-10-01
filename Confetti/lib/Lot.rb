
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

	def is(name, lspec: nil)
		raise "invalid lspec" if !lspec
		# raise "Lot #{name} does not exist" unless exists?(name)
		@name = name
		@lspec = lspec
		@lot_spec = @lspec.lots[name]
		raise "Lot #{name} does not exist in LSpec" if !@lot_spec
	end

	#-------------------------------------------------------------------------------------------

	def vobs
		ClearCASE::VOBs.new(@lot_spec.vobs)
	end

	def lots
		Lots.new(@lot_spec.lots, lspec: @lspec)
	end
	
	def nexp
		@lspec.nexp[@name]
	end

	#-------------------------------------------------------------------------------------------

	# Filter out elements not contained in lot

	def filter_elements(elements)
		files = []
		vobs.each do |vob|
			files.merge!(elements.filter_by_vob(vob))
		end
		ClearCASE::Elements.new(files)
	end
	
	def label(name, view: nil)
		raise "unimplemented"
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

	attr_reader :names

	def initialize(names, lspec: nil)
		raise "invalid lspec" if !lspec
		names = lspec.lots.keys if !names
		@names = names
		@lspec = lspec
	end

	def count
		@names.count
	end

	def each
		@names.each { |name| yield Confetti.Lot(name, @lspec) }
	end
end

#----------------------------------------------------------------------------------------------

# module All
# 
# #----------------------------------------------------------------------------------------------
# 
# class Lots
# 	include Enumerable
# 
# 	def initialize(names: nil, project: nil)
# 		@nexp = Lots.nexp
# 		@names = names == nil ? (@nexp[:lots]/:lot).rank1 : names
# 	end
# 
# 	def each
# 		@names.each { |name| yield Confetti.Lot(name, nexp: @nexp[:lots].select { |lot| lot.cadr.to_s == name }) }
# 		# @nexp["lots/lot/#{@name}"]
# 	end
# 
# 	def [](x)
# 		return @names[x] if x.is_a? Fixnum
# 		Lot.new(x, nexp: @nexp)
# 	end
# 
# 	def Lots.nexp
# 		Nexp(Config.path_in_view + '/lots.ne', :single)
# 	end
# end # Lots
# 
# #----------------------------------------------------------------------------------------------
# 
# end # module All

#----------------------------------------------------------------------------------------------

end # module Confetti
