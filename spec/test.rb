APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) 
$:.unshift(File.join(APP_ROOT, 'lib'))
$:.unshift(File.join(APP_ROOT, 'lib', 'external'))

require "bundler/setup"
require "active_support"
require 'httparty'


require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")


require 'pp'

page = Dumbo::Page.new(135) 
pp page.categories

#page = Dumbo::Page.new(197) 
#pp page.documents
