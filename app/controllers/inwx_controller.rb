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
    
  end
  
  def update_domains
    
    domrobot = INWX::Domrobot.new(ENV['INWX_DOMROBOT'])

    begin
      domrobot.login( current_user.inwx_credential.username, current_user.inwx_credential.password)
      
      current_user.inwx_domains.each do |d|
        @extracted_a_records = Array.new
        @extracted_cname_records = Array.new
        @a_records = domrobot.call('nameserver','info', {:domain => d.domain, :type => 'A'})
        @cname_records = domrobot.call('nameserver','info', {:domain => d.domain, :type => 'CNAME'})
        #  extracting A Records
        unless @a_records['resData'].blank?
          @a_records['resData']['record'].each do |r|
            @extracted_a_records << ARecord.new(:entry => r['content'], :name => r['name'])
          end
        end
        d.a_records = @extracted_a_records unless @extracted_a_records.blank?
        #  extracting CNAME Records
        unless @cname_records['resData'].blank?
          @cname_records['resData']['record'].each do |r|
            @extracted_cname_records << CnameRecord.new(:entry => r['content'], :name => r['name'])
          end
        end
        d.cname_records = @extracted_cname_records unless @extracted_cname_records.blank?
      end 
    rescue Exception => e
      Rails.logger.debug { e.to_yaml }
      flash[:error] = "Could not connect, please check you credentials!"
      render :update_domains
    end
  end
  
   
end
