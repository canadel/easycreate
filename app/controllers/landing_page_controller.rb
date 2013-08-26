require 'ostruct'

class LandingPageController < ApplicationController
  
  def index
    @resource=OpenStruct.new
    @domains = current_user ? current_user.inwx_domains : []
    @packages = Package.order('position ASC')

    if params[:resource]

      if params[:resource][:domain].blank?
        flash[:error] = 'Please, type domain name'
      else
        domain = InwxDomain.where(:domain => params[:resource][:domain]).first
        
        if domain.nil?
          flash[:error] = 'Please fill domain field'
        else
          resource = InwxDomain.where(:domain => params[:resource][:domain], :user_id => current_user.id).first
          flash[:error] = 'Domain already activated' if resource.dumbo_binary_state
        end
      end

      if params[:resource][:package].blank?
        flash[:error] = 'Please, select template'
      end

      if params[:resource][:project_name].blank?
        flash[:error] = 'Please, type project name'

      end
      
      unless flash[:error].blank?
        render 'index'
      else 
        
        if resource && params[:resource][:nameservers]
          
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

        end

        # create package via API
        page = Dumbo::Page.new :email => current_user.email 
        
        page_resp = page.create({
          account_id: current_user.id,
          name: domain.domain,
          title: params[:resource][:project_name],
          description: 'Created with EasyCreate One-Click',
          indexable: 1,
          label: 'Landing Page',
          template_id: 59,
          _package: params[:resource][:package]
        })

        flash[:notice] = 'Success! You should forward your domaain to new IP 37.235.63.140' if !resource;

        redirect_to pages_path
      end

    end

  end


private
  
  def domrobot
    @_domrobot ||= 
                  INWX::Domrobot.new(ENV['INWX_DOMROBOT']).tap do |robot|
                    robot.login( current_user.inwx_credential.username, 
                                 current_user.inwx_credential.password )
                  end
  end

end
