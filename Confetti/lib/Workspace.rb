
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class Workspace
	include Bento::Class

	constructors :is, :create
	members :root

	INT_BRANCH = "master"
	
	@@repos = ['confetti1', 'confetti1-import', 'classico1-bento', 'classico1-ruby']

	#------------------------------------------------------------------------------------------

	def is(dir = nil)
		@root = dir
	end

	#------------------------------------------------------------------------------------------

	def create(branch, tag = nil)
		tag ||= "master"
			
		Dir.chdir(root) do
			@@repos.each do |repo|
				System.command("git clone #{REPO_URL_BASE}/#{repo}.git -b #{tag}")
				System.command("git checkout -b #{branch}")
			end
		end
	end

	#------------------------------------------------------------------------------------------
	# add a db migration script

	def new_files
#		array = files.split(/,/)
#		array.size.times do |i|
#			System.command("git add " + array[i])
#		end
		# git ls-files --others --exclude-standard
	end

	#------------------------------------------------------------------------------------------
	# deploy: commit, push, tag, and merge to integration branch (i.e., master)

	def deploy(tag = nil, message = nil)
		message ||= "..."
		root_dir = root
		@@repos.each do |repo|
			Dir.chdir(root_dir/repo) do
				bb
				current_branch = `git rev-parse --abbrev-ref HEAD`.strip

				System.command('git commit -a -m "' + message + '"')
				System.command("git push origin #{current_branch}")
				if tag
					System.command("git tag -a " + tag)
					System.command("git push origin --tags")
				end
				System.command("git checkout #{INT_BRANCH}")
				System.command("git fetch origin #{INT_BRANCH}")
				merge = System.command("git merge #{current_branch}")
				System.command("git checkout #{current_branch}")
			end
		end
	end

	#------------------------------------------------------------------------------------------

	def rebase
	end

	#------------------------------------------------------------------------------------------

	def shell
		ENV['CONFETTI_BASE'] = nil
		ENV['CONFETTI_DATA'] = nil
		system("cmd /k " + (root/"confetti1/Confetti/bin/env.bat").to_win)
	end

	#------------------------------------------------------------------------------------------

	def root
		@root = Pathname.new(`git rev-parse --show-toplevel`.strip)/".." if !@root
		#@@ check if it's a confetti repo
		@root
	end

end # class Workspace

#----------------------------------------------------------------------------------------------

end # Confetti
