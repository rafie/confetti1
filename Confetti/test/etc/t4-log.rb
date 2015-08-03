
require 'Bento'

class A
	@@jojo="sdf"
	
	def x
		@@jojo
	end
end

a = A.new
puts a.x
Bento::Log.to = 'log'
debug "debug message"
info "this is some info"
warn "warning"
error "error message"
fatal "oh! this is very bad!"
