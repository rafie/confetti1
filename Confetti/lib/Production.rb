
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Production
	include Bento::Class

	constructors :is, :create
	members :prod_dir, :lockfile

	LOCK_FILENAME = "confetti.lock"
	PROD_SIGFILE = ".confetti"
	REPO_URL_BASE = "https://github.com/rafie"

	@@repos = ['confetti1', 'classico1-bento', 'classico1-ruby'] # , 'confetti1-import'
	
	#------------------------------------------------------------------------------------------

	def is(data_dir = nil)
		data_dir ||= ENV["CONFETTI_DATA"] 
		raise "Cannot determine data directory" if data_dir.empty?
		raise "Data directory #{data_dir} does not exist" if ! Dir.exists?(data_dir)
		raise "Directory #{data_dir} is not a Confetti production directory" if !Production.is_prod_dir?(data_dir)

		ENV["CONFETTI_DATA"] = data_dir

		# @source_repo_url_base = REPO_URL_BASE
		
		ctor(data_dir)
	end

	#------------------------------------------------------------------------------------------

	# tag == nil then take latest of production branch
	def create(data_dir = nil, tag = nil)
		data_dir ||= ENV["CONFETTI_DATA"]
		raise "Cannot determine data directory" if data_dir.empty?
		if !Dir.exists?(data_dir)
			FileUtils.mkdir_p(data_dir) or fatal "Cannot create #{data_dir}"
		else
			raise "Data directory #{data_dir} not empty" if !Dir.empty?(data_dir)
		end
		
		raise "Directory #{data_dir} is in a git workspace and cannot be used as a production directory" if Production.in_git_workspace?(data_dir)
		
		ctor(data_dir)

		File.open(@prod_dir/PROD_SIGFILE, "w").close()
		
		tag ||= "production"

		Dir.chdir(@prod_dir) do
			@@repos.each do |repo|
				System.command("git clone #{REPO_URL_BASE}/#{repo}.git -b #{tag}")
			end
		end
	end

	#------------------------------------------------------------------------------------------

	def ctor(data_dir)
		@prod_dir = Pathname.new(data_dir)
		@lockfile = Bento::LockFile.new(@prod_dir/LOCK_FILENAME)
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
	# create a file to isolate production db. If it already exists then another 
	# deployment is currently running.
	
	def try_lock
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

	#------------------------------------------------------------------------------------------

	def lock(seconds = 0)
		return if try_lock
		locked = false
		if seconds > 0
			begin
				sleep(500)
				locked = try_lock
				seconds -= 0.5
			end while !locked && seconds > 0
		else
			begin
				sleep(500)
			end while !try_lock
		end
	end

	#------------------------------------------------------------------------------------------

	def unlock
		return if @lockfile == nil
		@lockfile.close
		@lockfile = nil
	end

	#------------------------------------------------------------------------------------------
	# release: commit, push, tag, and merge to production branch

	def release(tag = nil, message = nil)
		message ||= "..."
		@@repos.each do |repo|
			Dir.chdir(@prod_dir/repo) do
				System.command("git commit -a -m "\" + message + "\"")
				System.command("git push origin")
				if tag
					System.command("git tag -a " + tag)
					System.command("git push origin --tags")
				end
				System.command("git fetch production")
				current_branch = `git rev-parse --abbrev-ref HEAD`
				System.command("git checkout production")
				System.command("git merge production")
				System.command("git checkout #{current_branch}")
			end
		end
	end

	#------------------------------------------------------------------------------------------

	def deploy(tag = nil)
		return false if !try_lock
		tag ||= "production"
		begin
			Dir.chdir(@prod_dir) do
				@@repos.each do |repo|
					System.command("git checkout --detach #{REPO_URL_BASE}/#{repo} -b #{tag}")
				end
			end
		rescue => x
			error "Error during deploy: " + x.to_s
		end
		unlock
		true
	end

	#------------------------------------------------------------------------------------------
	# execution of the db migration script that has been added

	def migrate_db(script_fname)
		# System.command("ruby", @prod_dir/confetti1/confetti/lib/" + scriptFileName)
	end

	#------------------------------------------------------------------------------------------
	private
	#------------------------------------------------------------------------------------------

	def self.in_git_workspace?(dir)
		Dir.chdir(dir) do
			# check if we're inside a git repo dir
			status = System.command("git status")
			return status.ok?
		end
		false
	end
	
	def self.is_prod_dir?(dir)
		File.exists?(Pathname.new(dir)/PROD_SIGFILE)
	end
end # class Production

#----------------------------------------------------------------------------------------------

end # Confetti

# tt dev deploy --initial
# tt dev deploy
