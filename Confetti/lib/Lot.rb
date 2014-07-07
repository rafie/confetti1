
require_relative 'Confetti'

module Confetti

TEST_META_DIR = "view"
LOT_NEXP_VIEWPATH = "/nbu.meta/confetti/lots.ne"

#----------------------------------------------------------------------------------------------

# (lots
#   (lot name
#      (vobs v1..vk)
#      (lots l1..lm)))

class Lot

	attr_reader :name

	def initialize(name, db: nil)
		# raise "Lot #{name} does not exist" unless exists?(name)
		@name = name
		@db = db
	end

	def vobs
		names = db[:vobs]
		names = !names ? [] : ~names
		return ClearCASE::VOBs.new(names)
	end

	def lots
		names = db[:lots]
		names = !names ? [] : ~names
		return Lots.new(names: names)
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

	private

	def db
		if @db == nil
			lots = Lots::db if @db == nil
			@db = (lots/:lot).select { |lot| lot.cadr.to_s == @name }[0]
			raise "lot #{@name} does not exist" if !@db
		end
		@db
	end
end # Lot

#----------------------------------------------------------------------------------------------

class Lots
	def initialize(names)
		@names = names
	end

	def each
		@names.each { |name| yield Lot.new(name) }
	end
end

#----------------------------------------------------------------------------------------------

module All

#----------------------------------------------------------------------------------------------

class Lots
	include Enumerable

	def initialize(names: nil)
		@db = Lots.db
		@names = names == nil ? (@db[:lots]/:lot).rank1 : names
	end

	def each
		@names.each { |name| yield Lot.new(name, db: @db[:lots].select { |lot| lot.cadr.to_s == name }) }
		@db["lots/lot/#{@name}"]
	end

	def [](x)
		return @names[x] if x.is_a? Fixnum
		Lot.new(x, db: @db)
	end

	def Lots.db
		if !CONFETTI_TEST
			view = ClearCASE::CurrentView.new
			meta_dir = view.fullPath
		else
			meta_dir = TEST_META_DIR
		end
		Nexp.from_file(meta_dir + LOT_NEXP_VIEWPATH, :single)
	end
end # Lots

#----------------------------------------------------------------------------------------------

end # module Confetti
