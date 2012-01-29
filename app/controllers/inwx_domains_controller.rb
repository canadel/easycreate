class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index   
  end
  
  def activate_dumbo
    
    # begin
      domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
      if current_user.inwx_domains.find(resource).a_records.where(:entry => "www.#{resource.domain}").exists?
        unless current_user.inwx_domains.find(resource).a_records.where(:name => "www.#{resource.domain}").first.eql?(ENV['DUMBO_IP'])
          record_id = resource.a_records.where(:name => "#{resource.domain}").first.inwx_id
          domrobot.call(  'nameserver',
                          'updateRecord',
                          { :id => record_id,
                            :content => ENV['DUMBO_IP']
                          }
                       )
        end
      else
        domrobot.call('nameserver','createRecord', {:domain => resource.domain, :type => 'A', :content => ENV['DUMBO_IP'], :name => ''})
      end
 
      if current_user.inwx_domains.find(resource).cname_records.where(:name => "www.#{resource.domain}").exists?
        unless current_user.inwx_domains.find(domain).cname_records.where(:name => "www.#{domain.domain}", :entry => domain).exists?
          record_id = domain.cname_records.where(:name => "www.#{domain.domain}").first.inwx_id
          domrobot.call(  'nameserver',
                          'updateRecord',
                          { :id => record_id,
                            :content => domain.domain
                          }
                       )
        end
      else
        domrobot.call('nameserver','createRecord', {:domain => domain.domain, :type => 'CNAME', :content => "#{domain.domain}", :name => 'www'})
      end
      redirect_to :action => update_domain, :id => domain.id, :update_view => true
  end
  
  def deactivate_dumbo
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    domain = InwxDomain.find(params[:domain_id])
    
    begin
      domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
      domrobot.call(  'nameserver',
                      'deleteRecord',
                      { :id => domain.a_records.where(:name => domain.domain).first.inwx_id }
                    )
      domrobot.call(  'nameserver',
                      'deleteRecord',
                      { :id => domain.cname_records.where(:name => "www.#{domain.domain}", :entry => domain.domain).first.inwx_id }
                    )
    rescue Exception => e
      
    end
    
    redirect_to :action => update_domain, :id => domain.id, :update_view => true
  end
  
  def update_domains
    begin
      current_user.inwx_domains.each { |d| update_domain(d.id) }
    rescue Exception => e
      flash[:error] = "Could not connect, please check you credentials!"
      @domains = current_user.inwx_domains
      render :update_domains
    end
    @domains = current_user.inwx_domains
  end
  
  
  def update_domain(domain_id = params[:domain_id], update_view = params[:update_view])
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
    
    domain = InwxDomain.find(domain_id)
    
    @extracted_a_records = Array.new
    @extracted_cname_records = Array.new
    @a_records = domrobot.call('nameserver','info', {:domain => domain.domain, :type => 'A'})
    @cname_records = domrobot.call('nameserver','info', {:domain => domain.domain, :type => 'CNAME'})
    #  extracting A Records
    unless @a_records['resData'].blank?
      @a_records['resData']['record'].each do |r|
        @extracted_a_records << ARecord.new(:entry => r['content'], :name => r['name'], :inwx_id => r['id']) unless r.blank?
      end
    end
    domain.a_records = @extracted_a_records
    #  extracting CNAME Records
    unless @cname_records['resData'].blank?
      @cname_records['resData']['record'].each do |r|
        @extracted_cname_records << CnameRecord.new(:entry => r['content'], :name => r['name'], :inwx_id => r['id']) unless r.blank?
      end
    end
    domain.cname_records = @extracted_cname_records

    unless update_view.blank?
        respond_to do |format|
        format.js {
          @domains = current_user.inwx_domains
          render :update_domains
        }
      end
    end
  end
  
  def get_domains
    respond_to do |format|

      format.html do
        if current_user.inwx_credential.username.empty? || current_user.inwx_credential.password.empty?
          flash[:error] = "Please setup your inwx credentials first!"
        end
      end # .html

      format.js do
        
    
        domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
    
        begin
          domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
          @domains = domrobot.call('domain','list',{ :pagelimit => 100000})
      
        rescue Exception => e
          flash[:error] = "Could not connect, please check you credentials!"
          render :get_domains
        end
    
        @temp = Array.new
        @domains['resData']['domain'].each do |d|
           @temp.push InwxDomain.new(:domain => d['domain'])
        end
        
        current_user.inwx_domains = @temp
    
        @domains = current_user.inwx_domains
        render 'update_domains.js.coffee'
        
      end # .js
    end
  end
  
  private
  # domain api
  def domrobot
    @_domrobot ||= INWX::Domrobot.new(ENV['INWX_DOMROBOT'])
  end

  # domain
  def resource 
    @_resource ||= InwxDomain.find(params[:domain_id])  
  end
  
  # user domains
  def resources 
    @_resources ||= current_user.inwx_domains
  end

  helper_method :resource, :resources

end


