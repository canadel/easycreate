# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")
require File.expand_path(File.join(File.dirname(__FILE__), 'crud_seg'))

require 'pp'

describe Dumbo::Domain do 


  let(:record) do
    { 'name'     => 'pro7deals.de', 
      'page_id'  => 1, 
      'wildcard' => nil }
  end

  let(:invalid_record) do
    { 'page_id'  => 1, 
      'wildcard' => nil }
  end

  let(:records) do
   [
    {'name'     => 'pro7deals.de', 
     'page_id'  => 1, 
     'wildcard' => nil }
    ] 
  end

  let(:non_exist_resource_id){ 999999 }
  let(:exist_resource_id    ){ 1      }

  let(:resource) { 'domains' }
  let(:resources){ 'domains' }


  %w( index show create update delete ).each do |action|
    it_should_behave_like action
  end

end # Dumbo::API



