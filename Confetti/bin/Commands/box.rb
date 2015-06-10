
require "mercenary"
require 'byebug'

module Confetti
module Commands
module Box

#----------------------------------------------------------------------------------------------

def self.enter(c)
	c.syntax 'enter [options] box-name'
	c.description 'enter box'

	c.option :foo, '-f FOO', '--foo FOO', 'foo it away'
	c.option :bar, 'b', '--bar', 'raise the bar'

	c.action do |args, options|
	end
end

#----------------------------------------------------------------------------------------------

def self.remove(c)
	c.syntax 'remove [options] box-name'
	c.description 'remove box'

	c.action do |args, options|
		args.each do |name|
			Confetti.Box(name).remove!
		end
	end
end

#----------------------------------------------------------------------------------------------

def self.push(c)
	c.syntax 'remove [options] box-name'
	c.description 'remove box'

	c.action do |args, options|
	end
end

#----------------------------------------------------------------------------------------------

def self.pop(c)
	c.syntax 'remove [options] box-name'
	c.description 'remove box'

	c.action do |args, options|
	end
end

#----------------------------------------------------------------------------------------------

def self.list(c)
	c.syntax 'list [options]'
	c.description 'list boxes'

	c.action do |args, options|
		default_box = Confetti::Config.box
		default_name = default_box ? default_box.name : ""
		Dir[Confetti::Config.boxes_path/'*'].each do |f|
			next if !File.directory?(f)
			box = File.basename(f)
			puts box + (default_name == box ? " *" : "")
		end
	end
end

#----------------------------------------------------------------------------------------------

def self.commands(c)
	c.syntax 'box [options]'
	c.description 'box commands'

	c.command :enter do |x| enter(x) ; end
	c.command :remove do |x| remove(x) ; end
	c.command :push do |x| push(x) ; end
	c.command :pop do |x| pop(x) ; end
	c.command :list do |x| list(x); end
end

#----------------------------------------------------------------------------------------------

end # Box
end # Commands
end # Confetti