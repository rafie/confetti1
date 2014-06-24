
# require 'nokogiri'
require 'Bento'

module Confetti

META_DIR = "."
LOT_XML_VIEWPATH = "/nbu.meta/confetti/lots.xml"
LOT_NEXP_VIEWPATH = "/nbu.meta/confetti/lots.ne"

#----------------------------------------------------------------------------------------------

# (lot L1
#    (vobs v1..vk)
#    (lots l1..lm))

class Lot
	class DB
		def initialize(name)
			@name = name
			# view = ClearCASE::CurrentView.new
			# @xml = Nokogiri::XML(File.open(view.fullPath + LOT_XML_VIEWPATH))
			@ne = Nexp.from_file(META_DIR + LOT_NEXP_VIEWPATH)
		end

		def exists?
			# !@xml.xpath("//lots/lot[@name='#{name}']").empty?
			@ne[:lots][@name] != nil
		end
	
		def vobNames(name)
			# @xml.xpath("//lots/lot[@name='#{name}']/vob/@name").map { |x| x.to_s }
			~@ne[:lots][@name][:vobs]
		end
	
		def lotNames(name)
			# @xml.xpath("//lots/lot[@name='#{name}']/lot/@name").map { |x| x.to_s }
			~@ne[:lots][@name][:lots]
		end
	end # DB

	attr_reader :name

	def initialize(name)
		# raise "Lot #{name} does not exist" unless DB.exists?(name)
		@name = name
		@db = nil
	end

	def vobs
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
		@db = DB.new if ! @db
		return @db
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

end # Lots

#----------------------------------------------------------------------------------------------

end # module Confetti
