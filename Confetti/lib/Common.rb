
require 'erb'
require 'fileutils'
# require 'nokogiri'
require 'ostruct'
require 'pathname'
require 'sqlite3'

require 'Bento'

module Confetti

unless const_defined?(:CONFETTI_COMMON__) # this handles const redefs due to code reloading
CONFETTI_COMMON__=1

# this should be determined by per-repo association
CONFETTI_CLEARCASE = true
CONFETTI_GIT = false

$confetti_test_mode = ENV["CONFETTI_TEST"].to_i == 1

KEEP_FS = ENV["CONFETTI_TEST_KEEP"].to_i == 1
TEST_WITH_CLEARCASE = ENV["CONFETTI_TEST_CCASE"].to_i == 1
TEST_ROOT_VOB = ENV["CONFETTI_ROOT_VOB"]

end # unless

def self.test_mode?; $confetti_test_mode; end

end # module Confetti
