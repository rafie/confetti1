
require 'Confetti'

module Confetti
module Commands

#----------------------------------------------------------------------------------------------

def self.mkview(c)
#byebug
		
	c.syntax "mkview --name <view name> --project <project name> --ver <project version_number> --cspec <configuration specification> --lspec <lot specification>"
	c.description "Create a view"
	c.option 'name', '-n NAME','--name NAME','Set the view name'
	c.option 'project', '-p PROJECT','--project PROJECT','Set project name for the view'
	c.option 'version_number', '-r VERS','--ver VERS','Set the version of the project. If ommited the latest version is considered'
	c.option 'cspec', '-c CSPEC','--cspec CSPEC','Set the cspec for the view definition'
	c.option 'lspec', '-l LSPEC','--lspec LSPEC','Set the lspec to be used'
	
	c.action do |_,options|
		
		name=options['name'] if options['name']
		name=nil if !options['name']
		
		project=Confetti.Project(options['project']) if options['project']
		project=nil if !options['project']
		
		vers=options['version_number'] if options['version_number']
		vers=nil if !options['version_number']
		
		cspec=options['cspec'] if options['cspec']
		cspec=nil if !options['cspec']
		
		lspec=options['lspec'] if options['lspec']
		lspec=nil if !options['lspec']
		puts "Creating view..."
		view = Confetti::View.create_from_command(name, project: project, version: vers, cspec: cspec, lspec: lspec)				
		puts "View #{view.name} created"
		
	end	
end

#----------------------------------------------------------------------------------------------
end # Commands
end # Confetti