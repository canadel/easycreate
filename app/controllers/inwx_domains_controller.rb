class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @domains = current_user.inwx_domains
  end
  
  def activate_dumbo
    # domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    #    domain = InwxDomain.find(params[:id])
    #    
    #    begin
    #      Rails.logger.debug { "Updating Domain: #{domain}" }
    #      if current_user.inwx_domains(domain).a_records.where(:entry => 'www').exists?
    #        domrobot.call()
    #    rescue Exception => e
    #      flash[:error] = "An error happened during processing your request."
    #    end
  end
  
  def deactivate_dumbo
    
  end
  

end