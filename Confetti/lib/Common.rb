
require 'erb'
require 'fileutils'
require 'json'
require 'ostruct'
require 'pathname'
require 'sqlite3'
require 'active_record'

require 'Bento'

module Confetti

unless const_defined?(:CONFETTI_COMMON__) # this handles const redefs due to code reloading
CONFETTI_COMMON__=1

# this should be determined by per-repo association
CONFETTI_CLEARCASE = true
CONFETTI_GIT = false
CONFETTI_MULTIVIEW = false

end # unless

end # module Confetti
