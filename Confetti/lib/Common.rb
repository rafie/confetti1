
require 'erb'
require 'fileutils'
# require 'nokogiri'
require 'ostruct'
require 'pathname'
require 'sqlite3'

require 'Bento'
# require 'Nexp'

module Confetti

# this should be determined by per-repo association
CONFETTI_CLEARCASE = true
CONFETTI_GIT = false

# now in Test.rb:
# TEST_MODE = false 
# TEST_WITH_CLEARCASE = false

end # module Confetti
