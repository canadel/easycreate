require 'ostruct'

class LandingPageController < ApplicationController
  
  def index
    @resource=OpenStruct.new
  end

end
