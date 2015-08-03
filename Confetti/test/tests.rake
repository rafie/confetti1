
ENV["CONFETTI_TEST_KEEP"] = ENV["KEEP"]
ENV["CONFETTI_TEST_CCASE"] = ENV["CCASE"]

# puts "CONFETTI_TEST_KEEP=" + ENV["CONFETTI_TEST_KEEP"].to_s
# puts "CONFETTI_TEST_CCASE=" + ENV["CONFETTI_TEST_CCASE"].to_s

test_libs = ["../lib", "../../../classico1-bento/Classico"]

Rake::TestTask.new do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		test1.rb
		db1.rb
		lot1.rb
		cspec1.rb
		project1.rb
		)]
#	t.verbose = true
end

#----------------------------------------------------------------------------------------------

namespace :test do

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("test") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		test1.rb
		)]
end

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("db") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		db1.rb
		)]
end

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("cspec") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		cspec1.rb
		)]
end

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("lot") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		lot1.rb
		)]
end

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("project") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		project1.rb
		)]
end

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("act") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		activity1.rb
		)]
end

#----------------------------------------------------------------------------------------------

namespace :tt do

#----------------------------------------------------------------------------------------------

Rake::TestTask.new("mkact") do |t|
	t.libs = test_libs
	t.test_files = FileList[%w(
		tt/mkact.rb
		)]
end

#----------------------------------------------------------------------------------------------

end # namespace tt

#----------------------------------------------------------------------------------------------

end # namespace test
