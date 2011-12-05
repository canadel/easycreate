class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @domains = current_user.inwx_domains
  end

end