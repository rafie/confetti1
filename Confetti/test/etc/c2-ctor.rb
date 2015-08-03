
# require 'Bento/lib/Class.rb'
require 'byebug'

$x = <<-END
	def X::Y(*args)
		x = A::B::X::Y.send(:new)
		x.send(:is, *args)
		x
	end
END


module Jojo
	def jojo
#		byebug	

		fq_klass = self.name
		klass = self.name.split("::")[-1]
		mod = self.name.split("::")[0..-2].join("::")
		mod_e = eval(mod)

#		byebug
		x = <<-END
			#{mod}.define_singleton_method(:#{klass}) do |*args|
				x = #{fq_klass}.send(:new)
				x.send(:is, *args)
				x
			end
		END
		#eval(x)
		mod.instance_eval(
#		eval("A::B::X").class_eval($x)
	end
end




module X

class Y
#	include Bento::Class
#	constructors :is

	extend Jojo
	jojo
	
	def is(c)
		@c = c
	end
	
end # Y

end # X

x = X.Y('sdf')
puts x




module A
module B
module X


class Y
#	include Bento::Class
#	constructors :is

#	eval("A::B::X").class_eval($x)
#	byebug
	
	extend Jojo
	jojo
	
	def is(c)
		@c = c
	end
	
end # Y

class Y1
#	include Bento::Class
#	constructors :is

	extend Jojo
	jojo

	def is(c)
		@c = c
	end
	
end # Y

end # X
end # B
end # A

x = A::B::X.Y('sdf')
puts x
x = A::B::X.Y1('sdf')
puts x



module A1
module B1
module X1

class Y1
#	include Bento::Class
#	constructors :is

	extend Jojo
	jojo

	def is(c)
		@c = c
	end
end # Y

end # X
end # B
end # A


byebug
x = A1::B1::X1.Y1('sdf')
puts x


#	A::B.class_eval(<<-END)
#		def B::C(*args)
#			x = B::C.send(:new)
#			x.send(:is, *args)
#			x
#		end
#	END


#	A::X.class_eval(<<-END)
#		def X::Y(*args)
#			x = A::X::Y.send(:new)
#			x.send(:is, *args)
#			x
#		end
#	END
