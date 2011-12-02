require "#{Rails.root}/lib/external/Domrobot.rb"

class InwxController < ApplicationController
  

  before_filter :authenticate_user!

  def index

  end

  def get_domains
    # if current_user.inwx_credential.username.empty? || current_user.inwx_credential.password.empty?
      flash[:error] = "Please setup your inwx credentials first!"
    # end
    
    
    # addr = "api.domrobot.com"
    #     user = "tschulz"
    #     pass = "Markus1979"
    # 
    #     domrobot = INWX::Domrobot.new(addr)
    # 
    #     result = domrobot.login(user,pass)
    #     puts YAML::dump(result)
    #      
    #      
    #     result = domrobot.call('domain', 'list')
    #     puts YAML::dump(result)
    
  end
  
   
end
