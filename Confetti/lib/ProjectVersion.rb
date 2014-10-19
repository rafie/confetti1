
require_relative 'Common'

module Confetti

#----------------------------------------------------------------------------------------------

class ProjectVersion
	include Bento::Class

	constructors :is, :create
	members :id, :version, :project, :cspec

	attr_reader :version, :project, :cspec

	def is(version, *opt, project: nil)
		raise "invalid project" if !project
	end

	def create(version, *opt, project: nil, version: nil, cspec: nil)
		raise "invalid project" if !project
	end

end

#----------------------------------------------------------------------------------------------

class ProjectVersions
	include Enumerable

	attr_reader :names

	def initialize(versions, project: nil)
		raise "invalid project" if !project
		@versions = versions
	end

	def count
		@versions.count
	end

	def each
		@versions.each { |version| yield Confetti.Version(version: version, project: @project) }
	end
end

#----------------------------------------------------------------------------------------------

end
