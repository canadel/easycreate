# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")


describe Dumbo::API do 
  
  specify{ described_class.should respond_to(:index) }


end # Dumbo::API



