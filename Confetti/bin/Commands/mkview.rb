
require 'mercenary'
require 'Confetti'

module Confetti
module Commands

#----------------------------------------------------------------------------------------------

def self.mkview(c)
	c.syntax "mkview --name <view name> --project <project name> --version <project version> --cspec <configuration specification> --lspec <lot specification>"
	c.description "Create a view"

	c.option :name,    '-n NAME', '--name NAME', 'Set the view name'
	c.option :project, '-p NAME', '--project NAME', 'Set project name for the view'
	c.option :version, '-v VER',  '--ver VER', 'Set the version of the project. If ommited the latest version is considered'
	c.option :cspec,   '-c FILE', '--cspec FILE', 'Set the cspec for the view definition'
	c.option :lspec,   '-l FILE', '--lspec FILE', 'Set the lspec to be used'

	c.action do |args, options|
		view = Confetti::View.create(options.name, options.project, options.version, options.cspec, options.lspec)				
	end
end

#----------------------------------------------------------------------------------------------

end # Commands
end # Confetti
