APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) 
$:.unshift(File.join(APP_ROOT, 'lib'))
$:.unshift(File.join(APP_ROOT, 'lib', 'external'))

require "bundler/setup"
require "active_support"
require 'httparty'


require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")


require 'pp'

pages = Dumbo::Template.index
  
pp pages

# pp page = Dumbo::Template.new(1500).show

