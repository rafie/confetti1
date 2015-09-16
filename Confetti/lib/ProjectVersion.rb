
require_relative 'Common'
require_relative 'Project'
require_relative '../../../confetti1-import/lib/confetti1/import/Version.rb'

module Confetti

#----------------------------------------------------------------------------------------------

module DB

class ProjectVersion < ActiveRecord::Base
end

end # DB

#----------------------------------------------------------------------------------------------

class ProjectVersion
	include Bento::Class

	constructors :is, :create, :import
	members :id, :version, :project, :cspec, :projectid

	attr_reader :version, :project, :cspec, :id

	def is(version, *opt, project: nil)
		projectversion=DB::ProjectVersion.find_by(project_id:project.id , version: version)
		@version=version
		@id=projectversion.id		
		@project=projectversion.project_id
		@cspec=projectversion.cspec
		
	end
	def import(version, *opt, project: nil)
	
		oProject=Project.is(project)
		@projectid=oProject.id
		@version=version
		
		cccs=ClearCASE::Configspec.from_s(File.read(Confetti1::Import.Version(project + '/' + @version).cspecfile))
		@cspec = Confetti::CSpec.from_configspec(cccs)
		create_db_record
	end

	def create(version, *opt, project: nil, cspec: nil)
		raise "invalid project" if !project
	end
	def create_db_record
		
		row = DB::ProjectVersion.new do |r|
			r.project_id = @projectid
			r.version = @version.split('.').last(2).join('.')
			r.cspec = @cspec.to_s
		end
		row.save

		#rescue
		#	raise "Project: failed to add version with name='#{@version}' (already exists?)"
	end

end

#----------------------------------------------------------------------------------------------

class ProjectVersions
	include Enumerable
	include Bento::Class

	constructors :find
	members :versions, :project, :names

	attr_reader :names, :versions

	#def initialize(versions, project: nil)
	#	raise "invalid project" if !project
	#	@versions = versions
	#end 
	
	def find(project_name)
		
		@project = Confetti.Project(project_name)
		@versions = DB::ProjectVersion.where("project_id=?", @project.id)
		@names=[]
		@versions.each { |version| @names << version.version}
		@names = @names.map {|x| x.split('.').map{|y| y.to_i}}.sort.map {|x| x.join('.')}
		@versions
	end
	def latest		
		@names.last
	end
	def latest_full_name
		@project.name + '.' + latest
	end
	def count
		@versions.count
	end

	def each
		@versions.each { |version| yield Confetti.ProjectVersion(version, project: @project) }
	end
	
end

#----------------------------------------------------------------------------------------------

end
