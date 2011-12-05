require "#{Rails.root}/lib/external/Domrobot.rb"

class InwxController < ApplicationController
  

  before_filter :authenticate_user!

  def index

  end

  def get_domains
    if current_user.inwx_credential.username.empty? || current_user.inwx_credential.password.empty?
      flash[:error] = "Please setup your inwx credentials first!"
    end
    
    
    
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    
    begin
      domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
      @domains = domrobot.call('domain','list')
      
    rescue Exception => e
      flash[:error] = "Could not connect, please check you credentials!"
      render :get_domains
    end
    
    @temp = Array.new
    @domains['resData']['domain'].each do |d|
       @temp.push InwxDomain.new(:domain => d['domain'])
    end
    current_user.inwx_domains = @temp
    
    # puts YAML::dump(result)
         
    #      
    #     result = domrobot.call('domain', 'list')
    #     puts YAML::dump(result)
    
  end
  
   
end
