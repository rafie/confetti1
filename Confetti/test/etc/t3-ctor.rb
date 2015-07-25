
class A
	def initialize(a, *opt, b: nil)
		puts "joo"
	end
end

a = A.new(1, b: "sdfg")
