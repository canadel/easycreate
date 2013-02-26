class InwxDomainsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index   
  end
  
  def activate_dumbo
    
    # create or update address record
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

    # create or update cname record
    if current_user.inwx_domains.find(resource).cname_records.where(:name => "www.#{resource.domain}").exists?
      unless current_user.inwx_domains.find(resource).cname_records.where(:name => "www.#{resource.domain}", :entry => resource).exists?
        record_id = resource.cname_records.where(:name => "www.#{resource.domain}").first.inwx_id
        domrobot.call(  'nameserver',
                        'updateRecord',
                        { :id => record_id,
                          :content => resource.domain
                        }
                     )
      end
    else
      domrobot.call('nameserver','createRecord', {:domain => resource.domain, :type => 'CNAME', :content => "#{resource.domain}", :name => 'www'})
    end
    
    # create page and domain
    page = Dumbo::Page.new :email => current_user.email 
    
    page_resp = page.create({
      account_id: current_user.id,
      name: resource.domain,
      title: 'Welcome',
      template_id: 59,
      description: 'Created with EasyCreate',
      indexable: 1,
      label: 'Landing Page',
      _with_domain: 1
    })

    # page_id = page_resp.parsed_response['id']

    # # create domain
    # domain = Dumbo::Domain.new :email => current_user.email
    
    # domain_resp = domain.create({
    #   name: resource.domain,
    #   page_id: page_id,
    #   wildcard: 1
    # })

    # # update page
    # page = Dumbo::Page.new :email => current_user.email, :id => page_id
   
    # page.update({
    #   domain_id: domain_resp.parsed_response['id'] 
    # })
    
    redirect_to :action => :update_domain, :id => resource.id, :update_view => true
  end
  
  def deactivate_dumbo
    begin
      domrobot.call(  'nameserver',
                      'deleteRecord',
                      { :id => resource.a_records.where(:name => resource.domain).first.inwx_id }
                    )

      # domrobot.call(  'nameserver',
      #                 'deleteRecord',
      #                 { :id => resource.cname_records.where(:name => "www.#{resource.domain}", :entry => resource.domain).first.inwx_id }
      #               )

    rescue Exception => e
    
    end
    
    redirect_to :action => :update_domain, :id => resource.id, :update_view => true
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
    
    @extracted_a_records = []
    @extracted_cname_records = []
    @a_records = domrobot.call('nameserver','info', {:domain => resource.domain, :type => 'A'})
    @cname_records = domrobot.call('nameserver','info', {:domain => resource.domain, :type => 'CNAME'})
    #  extracting A Records
    unless @a_records['resData'].blank?
      @a_records['resData']['record'].each do |r|
        @extracted_a_records << ARecord.new(:entry => r['content'], :name => r['name'], :inwx_id => r['id']) unless r.blank?
      end
    end
    resource.a_records = @extracted_a_records
    #  extracting CNAME Records
    unless @cname_records['resData'].blank?
      @cname_records['resData']['record'].each do |r|
        @extracted_cname_records << CnameRecord.new(:entry => r['content'], :name => r['name'], :inwx_id => r['id']) unless r.blank?
      end
    end
    resource.cname_records = @extracted_cname_records

    unless update_view.blank?
        respond_to do |format|
        format.js {
          @domains = current_user.inwx_domains
          render 'update_domains.js.coffee'
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
    @_domrobot ||= 
                  INWX::Domrobot.new(ENV['INWX_DOMROBOT']).tap do |robot|
                    robot.login( current_user.inwx_credential.username, 
                                 current_user.inwx_credential.password )
                  end
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


