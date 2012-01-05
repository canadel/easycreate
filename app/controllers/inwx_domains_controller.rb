class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @domains = current_user.inwx_domains
  end
  
  def activate_dumbo
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    domain = InwxDomain.find(params[:id])
     
    # begin
      Rails.logger.debug { "Updating Domain: #{domain.domain}" }
      unless current_user.inwx_domains(domain).first.a_records.where(:entry => "www.#{domain.domain}").exists?
        unless current_user.inwx_domains(domain).first.a_records.where(:name => "www.#{domain.domain}").entry.eql?('184.106.177.132')
          Rails.logger.debug { "DEBUG: we would need to update #{domain.domain} A Record" }
          domrobot.call('nameserver','updateRecord', {:id => domain.a_records.where(:name => "www.#{domain.domain}").first.inwx_id, :content => '184.106.177.132'})
        end
      else 
        domrobot.call('nameserver','createRecord', {:domain => domain.domain, :type => 'A', :content => '184.106.177.132', :name => ''})
        Rails.logger.debug { "DEBUG: we created #{domain.domain} A Record" }
      end
 
      if current_user.inwx_domains(domain).first.cname_records.where(:name => "www.#{domain.domain}").exists?
        unless current_user.inwx_domains(domain).first.cname_records.where(:name => "www.#{domain.domain}", :entry => domain).exists?
          Rails.logger.debug { "DEBUG: we would need to update #{domain.domain} CNAME Record" }
        end
      else
        Rails.logger.debug { "DEBUG: we would need to create #{domain.domain} CNAME Record" }
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