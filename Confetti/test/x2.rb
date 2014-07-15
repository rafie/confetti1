
require 'Bento'
require 'byebug'

class A
	def <<(*x)
		puts x
	end
end

a = A.new
a << [1,2]

#byebug
#db = Bento::DB.create() << <<-SQL
#  create table numbers (
#    name varchar(30),
#    val int
#  );
#SQL
db = Bento::DB.create(schema: '../db/global.schema.sql', data: 'net/confetti/global.data.sql')
byebug
db["select * from projects"].each do |x|
	puts x[:name]
end
# db.cleanup
