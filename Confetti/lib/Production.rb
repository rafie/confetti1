
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Production
	include Bento::Class

	constructors :is, :create
	members :prod_dir, :filelock

	LOCK_FILENAME = "confetti.lock"
	PROD_SIGFILE = ".confetti"
	REPO_URL_BASE = "https://github.com/rafie"
	PRODUCTION_BRANCH = "production"

	@@repos = ['confetti1', 'classico1-bento', 'classico1-ruby'] # , 'confetti1-import'
	
	#------------------------------------------------------------------------------------------

	def is(base_dir = nil)
		base_dir ||= ENV["CONFETTI_PROD"] 
		raise "Cannot determine production base directory" if base_dir.empty?
		raise "Production base directory #{data_dir} does not exist" if ! Dir.exists?(base_dir)
		raise "Directory #{base_dir} is not a Confetti production directory" if !Production.is_prod_dir?(base_dir)

		# ENV["CONFETTI_DATA"] = data_dir

		# @source_repo_url_base = REPO_URL_BASE
		
		ctor(base_dir)
	end

	#------------------------------------------------------------------------------------------

	# tag == nil then take latest of production branch

	def create(base_dir = nil, tag = nil)
		base_dir ||= ENV["CONFETTI_PROD"]
		raise "Cannot determine production base directory" if base_dir.empty?
		if !Dir.exists?(base_dir)
			FileUtils.mkdir_p(base_dir) or fatal "Cannot create #{base_dir}"
		else
			raise "Production base directory #{base_dir} not empty" if !Dir.empty?(base_dir)
		end
		
		raise "Directory #{base_dir} is in a git workspace and cannot be used as a production directory" if Production.in_git_workspace?(base_dir)
		
		ctor(base_dir)

		IO.write(@prod_dir/PROD_SIGFILE, "")

		tag ||= PRODUCTION_BRANCH

		Dir.chdir(@prod_dir) do
			@@repos.each do |repo|
				System.command("git clone #{REPO_URL_BASE}/#{repo}.git -b #{tag}")
			end
		end
	end

	#------------------------------------------------------------------------------------------

	def ctor(base_dir)
		@prod_dir = Pathname.new(base_dir).realpath
		@filelock = Bento::FileLock.new(@prod_dir/LOCK_FILENAME)
	end

	private :ctor

	#------------------------------------------------------------------------------------------

	def self.in_git_workspace?(dir)
		Dir.chdir(dir) do
			# check if we're inside a git repo dir
			status = System.command("git status")
			return status.ok?
		end
		false
	end
	
	#------------------------------------------------------------------------------------------

	def self.is_prod_dir?(dir)
		File.exists?(Pathname.new(dir)/PROD_SIGFILE)
	end

	#------------------------------------------------------------------------------------------
	# create a file to isolate production db. If it already exists then another 
	# deployment is currently running.
	
	def try_lock
		@filelock.try_lock
	end

	def lock(seconds = 0)
		@filelock.lock(seconds)
	end

	def unlock
		@filelock.unlock
	end

	#------------------------------------------------------------------------------------------

	def release(tag = nil)
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
	
end # class Production

#----------------------------------------------------------------------------------------------

end # Confetti

# tt dev release --initial
# tt dev release
