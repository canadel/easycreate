class InwxCredentialsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
  end
  
  def edit
    @inwx_credential = current_user.inwx_credential
    
  end
  
  def update
    
  end

end
