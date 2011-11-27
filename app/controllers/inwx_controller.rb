require "#{Rails.root}/lib/external/Domrobot.rb"

class InwxController < ApplicationController
  

  before_filter :authenticate_user!

  def index

  end

  def get_domains
    addr = "api.domrobot.com"
    user = "tschulz"
    pass = "Markus1979"

    domrobot = INWX::Domrobot.new(addr)

    result = domrobot.login(user,pass)
    puts YAML::dump(result)
     
     
    result = domrobot.call('domain', 'list')
    puts YAML::dump(result)
    
  end
   
end
