# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

require File.expand_path(File.join(File.dirname(__FILE__), 'crud_seg'))

require 'pp'

describe Dumbo::Template do 

  let(:record) do
    { "name"=>"ahoy_index.html",
      "account_id"=>2,
      "content"=> ""}
  end

  let(:invalid_record) do
    { "account_id"=>2,
      "content"=> nil }
  end

  let(:records) do
    [
      { "name"        =>  "ahoy_index.html",
        "account_id"  =>  2,
        "content"     =>  "" }
    ] 
  end

  let(:non_exist_resource_id){ 999999 }
  let(:exist_resource_id    ){ 1      }

  let(:resource) { 'templates' }
  let(:resources){ 'templates' }


  %w( index show create update delete ).each do |action|
    it_should_behave_like action
  end

end # Dumbo::API

