lib_dir = File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'test/unit'
require 'contest'
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)
require 'go'