# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

describe Dumbo::Document do 

  let(:record) do
    { "slug"    =>  "aktuele-news3",
      "kind"    =>  "article",
      "title"   =>  "Yeah, it's news #3",
      "template_id" => 67,
      "page_id" =>  135,
      "language"=>  nil,
      "timezone"=>  "Europe/Berlin",
      "content" =>  "<p>\r\n\tInstead of looping over an existing collection, you can define a range of numbers to loop through. The range can be defined by both literal and variable numbers:</p>\r\n",
      "published_at"=>  "2011-12-01T17:26:00Z",
      "markup"  =>  "markdown",
      "description"=> nil
    }
  end

  let(:invalid_record) do
    { "slug"    =>  nil,
      "title"   =>  "Yeah, it's news #3",
      "page_id" =>  135,
      "language"=>  nil,
      "timezone"=>  "Europe/Berlin",
      "content" =>  "<p>\r\n\tInstead of looping over an existing collection, you can define a range of numbers to loop through. The range can be defined by both literal and variable numbers:</p>\r\n",
      "published_at"=>  "2011-12-01T17:26:00Z",
      "markup"  =>  "markdown",
      "description"=> nil
    }
  end

  let(:records) do
   [
      record
    ] 
  end

  let(:non_exist_resource_id){ 999999 }
  let(:exist_resource_id    ){ 1      }

  let(:resource) { 'documents' }
  let(:resources){ 'documents' }

  let(:non_exist_parent_resource_id){ 999999  }
  let(:exist_parent_resource_id)    { 1       }
  let(:parent_resource)             { 'pages' }






end # Dumbo::Document
