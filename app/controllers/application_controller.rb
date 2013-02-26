require "#{Rails.root}/lib/external/Domrobot.rb"
require "#{Rails.root}/lib/external/dumbo/dumbo.rb"

class ApplicationController < ActionController::Base
  protect_from_forgery
end
