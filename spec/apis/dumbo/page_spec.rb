# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")
require File.expand_path(File.join(File.dirname(__FILE__), 'crud_seg'))

require 'pp'

describe Dumbo::Page do 


  let(:record) do
    { 'name'        => 'pro7deals.de', 
      'title'       => nil, 
      'template_id' => 1, 
      'indexable'   => false, 
      'account_id'  => 3, 
      'description' => nil }
  end

  let(:invalid_record) do
    { 'title'       => nil,  
      'description' => nil  }
  end

  let(:records) do
   [
    { 'name'        => 'pro7deals.de', 
      'title'       => nil, 
      'template_id' => 1, 
      'indexable'   => false, 
      'account_id'  => 3, 
      'description' => nil }
    ] 
  end

  let(:non_exist_resource_id){ 999999 }
  let(:exist_resource_id    ){ 1      }

  let(:resource) { 'pages' }
  let(:resources){ 'pages' }


end # Dumbo::API



