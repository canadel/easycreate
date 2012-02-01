# -*- encoding : utf-8 -*-

ENV["RAILS_ENV"] ||= 'test'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) 
$:.unshift(File.join(APP_ROOT, 'lib'))
$:.unshift(File.join(APP_ROOT, 'lib', 'external'))

require "bundler/setup"

require "active_support"
require 'httparty'
require 'webmock/rspec'

Dir[File.join(APP_ROOT, "spec/support/**/*.rb")].each {|f| require f}


def json_response
  ActiveSupport::JSON.decode @response.body
end

def json_encode obj
  ActiveSupport::JSON.encode obj
end


RSpec.configure do |config|
  config.mock_with :rspec
  include WebMock::API

  config.before(:suite) do
    WebMock.reset!
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  config.after(:suite) do
    WebMock.allow_net_connect!
  end

end


