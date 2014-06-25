
require_relative 'Common'

module Confetti

TEST_META_DIR = "view"
LOT_XML_VIEWPATH = "/nbu.meta/confetti/lots.xml"
LOT_NEXP_VIEWPATH = "/nbu.meta/confetti/lots.ne"

#----------------------------------------------------------------------------------------------

# (lots
#   (lot name
#      (vobs v1..vk)
#      (lots l1..lm)))

class Lot

	attr_reader :name

	def initialize(name)
		# raise "Lot #{name} does not exist" unless DB.exists?(name)
		@name = name
		@db = nil
	end

	def vobs
		byebug
		names = db.vobNames(@name)
		return ClearCASE::VOBs.new(names)
	end

	def lots
		names = db.lotNames(@name)
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
	
	private

	def db
		db = Lots::DB.new if ! @db
		return @db
	end

	def exists?(name)
		@ne[:lots][name] != nil
	end

	def vobNames(name)
		~@ne[:lots][name][:vobs]
	end

	def lotNames(name)
		~@ne[:lots][name][:lots]
	end
	
	def nexp
		@ne
	end
end # Lot

#----------------------------------------------------------------------------------------------

class Lots
	include Enumerable

	def initialize(names: nil)
		@ne = Lots.db
		@names = names == nil ? @ne.cdr.map(:lot) { |lot| ~lot.cadr } : names
	end

	def each
		@names.each { |name| yield Lot.new(name) }
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
