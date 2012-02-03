# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

describe Dumbo::Category do 


  let(:record) do
  end

  let(:invalid_record) do
  end

  let(:records) do
   [
    ] 
  end

  let(:non_exist_resource_id){ 999999 }
  let(:exist_resource_id    ){ 1      }

  let(:resource) { 'categories' }
  let(:resources){ 'categories' }

  let(:non_exist_parent_resource_id){ 999999  }
  let(:exist_parent_resource_id)    { 1       }
  let(:parent_resource)             { 'pages' }


end # Dumbo::API