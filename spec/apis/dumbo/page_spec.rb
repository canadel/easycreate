# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

require 'pp'

describe Dumbo::Page do 

  def stub_valid_request_index_on_empty
    stub_request(:get, "http://www.dumbocms.com/api/v1/pages.json").
           with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
           to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_valid_request_index_having_records
    stub_request(:get, "http://www.dumbocms.com/api/v1/pages.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, 
                   :body => json_encode(records),
                   :headers => {"Content-Type"=>"application/json; charset=utf-8"})
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

  context 'when GET index', Dumbo::Page do

    specify{ described_class.should respond_to(:index) }

    it 'should make request with valid path' do
      stub_valid_request_index_on_empty
      described_class.index
      WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/pages.json")
    end

    describe 'when pages empty' do
      it 'should return empty' do
        stub_valid_request_index_on_empty
        response = described_class.index
        response.body.should be_empty
      end
    end # when pages empty

    describe 'when pages have records' do
      it 'should return json array of records' do
        stub_valid_request_index_having_records
        response = described_class.index
        response.body.should_not be_empty
        response.parsed_response.should == records
      end
    end # when pages have records

  end # context 'GET /index' 




end # Dumbo::API
