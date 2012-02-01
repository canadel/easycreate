# -*- encoding : utf-8 -*-

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'rspec/rails'
require 'shoulda-matchers'
require 'httparty'
require 'webmock/rspec'
require 'capybara/rspec'


def json_response
    ActiveSupport::JSON.decode @response.body
end


RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.mock_with :rspec
  include WebMock::API

  config.before(:suite) do
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  config.after(:suite) do
    WebMock.allow_net_connect!
  end

end


