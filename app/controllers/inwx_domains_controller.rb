class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @domains = current_user.inwx_domains
  end
  
  def activate_dumbo
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    domain = InwxDomain.find(params[:id])
     
    # begin
      Rails.logger.debug { "Updating Domain: #{domain}" }
      if current_user.inwx_domains(domain).first.a_records.where(:entry => "www.#{domain}").exists? 
        Rails.logger.debug { "DEBUG: we would need to update #{domain} A Record" } unless 
      else
        Rails.logger.debug { "DEBUG: we would need to create #{domain} A Record" }
      end
 
      if current_user.inwx_domains(domain).first.cname_records.where(:name => "www.#{domain}", :entry => domain).exists
        Rails.logger.debug { "DEBUG: we would need to update #{domain} CNAME Record" }
      else
        Rails.logger.debug { "DEBUG: we would need to create #{domain} CNAME Record" }
      end
       # domrobot.call()
    # rescue Exception => e
      # Rails.logger.debug { "Error while updating: \n #{e.to_yaml}" }
      # flash[:error] = "An error happened during processing your request."
    # end
    render :nothing => true
  end
  
  def deactivate_dumbo
    
  end
  

end