require 'ostruct'

class LandingPageController < ApplicationController
  
  def index
    @resource=OpenStruct.new
    @domains = current_user.inwx_domains
    
    if params[:resource]

      if params[:resource][:project_name].blank?
        flash[:error] = 'Please, type project name'
      end

      if params[:resource][:domain].blank?
        flash[:error] = 'Please, type domain name'
      else
        domain = InwxDomain.where(:domain => params[:resource][:domain]).first
        flash[:error] = 'Domain not found' if domain.nil?
      end

      if params[:resource][:package].blank?
        flash[:error] = 'Please, select template'
      end

      unless flash[:error].blank?
        render 'index'
      else 

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

        redirect_to pages_path
      end

    end

  end

end
