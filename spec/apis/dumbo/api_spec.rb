# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")


describe Dumbo::API do 
  
  specify{ described_class.should respond_to(:index) }



  # [:show, :create, :update, :delete].each do |action|
  #   specify{ subject.should respond_to(action, 1)}
  # end

end # Dumbo::API



