class InwxCredentialsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
  end
  
  def edit
  end
  
  def update
    if resource.update_attributes(params[:inwx_credential])
      redirect_to root_path, notice: 'INWX credintals updated!'
    else
      render :edit
    end
  end


  private
  def resource
    @_inwx_credential ||= current_user.inwx_credential
  end

  helper_method :resource
end
