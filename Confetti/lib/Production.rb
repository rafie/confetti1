
require_relative 'Common'

require 'FileUtils'

module Confetti

#----------------------------------------------------------------------------------------------

class Production
	include Bento::Class

	constructors :is, :create
#	members

	LOCK_FILENAME = "confetti.lock"
	REPO_URL_BASE = "https://github.com/rafie"

	@@repos = ['confetti1', 'confetti1-import', 'classico1-bento', 'classico1-ruby']
	
	#------------------------------------------------------------------------------------------
	
	def is(data_dir = nil)
		data_dir ||= ENV["CONFETTI_DATA"]
		fatal "Cannot determine data directory" if data_dir.empty?
		fatal "Data directory #{data_dir} does not exist" if ! Dir.exists?(data_dir)
		ENV["CONFETTI_DATA"] = data_dir
		@prod_dir = Pathname.new(data_dir)

		@source_repo_url_base = REPO_URL_BASE
	end

	#------------------------------------------------------------------------------------------

	# tag==nil then take latest of production branch
	def create(data_dir = nil, tag = nil)
		data_dir ||= ENV["CONFETTI_DATA"]
		fatal "Cannot determine data directory" if data_dir.empty?
		if !Dir.exists?(data_dir)
			FileUtils.mkdir_p(data_dir) or fatal "Cannot create #{data_dir}"
		else
			fail "Data directory #{data_dir} not empty" if !Dir.empty?(data_dir)
		end
		@prod_dir = Pathname.new(data_dir)
		Dir.chdir(@prod_dir) do
			@repos.each do |repo|
				System.command("git clone #{REPO_URL_BASE}/#{repo}.git -b #{tag}")
			end
		end
	end

	#------------------------------------------------------------------------------------------
	# add a db migration script

#	def add_new_files(files)
#		array = files.split(/,/)
#		array.size.times do |i|
#			System.command("git add " + array[i])
#		end 
#	end

	#------------------------------------------------------------------------------------------
	# commit and push changes

	def commit_and_push(tag, message)
		begin
			System.command("git commit -m " + message)
			System.command("git tag" + tag)
			rescue
				puts("nothing to commit") 
			end
		System.command("git push origin :" + tag )
	end

	#------------------------------------------------------------------------------------------
	# create a file to isolate production db. If it already exists then another 
	# deployment is currently running.
	
	def lock
		lockfname = @prod_dir/LOCK_FILENAME
		lockfile = File.open(lockfname, File::RDWR|File::CREAT, 0644)
		locked = lockfile.flock(File::LOCK_EX|File::LOCK_NB) != false
		if !locked
			lockfile.close
			return false
		end
		@lockfile = lockfile
		true
	end

	def unlock
		return if @lockfile == nil
		@lockfile.close
		@lockfile = nil
	end

	#------------------------------------------------------------------------------------------

	def deploy(tag)
		begin
			Dir.chdir(@prod_dir) do
				@repos.each do |repo|
					System.command("git checkout --detach #{REPO_URL_BASE}/#{repo} -b #{tag}")
					end
				end
			end
		rescue => x
			error "Error during deploy: " + x.to_s
		end
	end

	#------------------------------------------------------------------------------------------
	# execution of the db migration script that has been added

	def migrate_db(scriptFileName)
		# System.command("ruby", @prod_dir/confetti1/confetti/lib/" + scriptFileName)
	end

end # Deployment

#----------------------------------------------------------------------------------------------

end # Confetti

# tt dev deploy --initial
# tt dev deploy