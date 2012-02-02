# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

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

  let(:non_exist_page_id){ 999999 }
  let(:exist_page_id    ){ 1      }

  def stub_valid_request_on_page_non_exists(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/pages/#{non_exist_page_id}.json").
           with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
           to_return(:status => 404, :body => "", :headers => {})
  end

  def stub_valid_request_on_exists_page(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/pages/#{exist_page_id}.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, 
                   :body => json_encode(record),
                   :headers => {"Content-Type"=>"application/json; charset=utf-8"})
  end

  def stub_valid_request_index_on_empty(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/pages.json").
           with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
           to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_valid_request_index_having_records(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/pages.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, 
                   :body => json_encode(records),
                   :headers => {"Content-Type"=>"application/json; charset=utf-8"})
  end

  context 'when GET index' do

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



  context 'SHOW particular page' do

    context 'when page exists' do
      it 'should be success' do
        stub_valid_request_on_exists_page
        page = described_class.new(exist_page_id)
        response = page.show
        WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/pages/#{exist_page_id}.json")
        response.code.should == 200
      end

      it 'should return page json object by requested id' do
        stub_valid_request_on_exists_page
        page = described_class.new(exist_page_id)
        response = page.show
        response.parsed_response.should == record
      end
    end # context 'when page exists'


    context 'when page not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_page_non_exists
        page = described_class.new(non_exist_page_id)
        lambda{
          page.show
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when page not exists'

  end # context 'when GET particular page'


  context 'CREATE page' do
    context 'when page valid' do
      it 'should return success' do
        stub_valid_request_index_on_empty(:post)
        page = described_class.new
        response = page.create(record)
        WebMock.should have_requested(:post, "http://www.dumbocms.com/api/v1/pages.json")
        response.code.should == 200
      end
    end

    context 'when page invalid' do
      it 'should raise ArgumentError error' do
        stub_valid_request_index_on_empty(:post)
        page = described_class.new
        lambda{
          page.create(invalid_record)
        }.should raise_error(ArgumentError)
      end      
    end

  end # context 'when CREATE page'



  context 'UPDATE page' do

    context 'when page exists' do
      context 'when page valid' do
        it 'should be success' do
          stub_valid_request_on_exists_page(:put)
          page = described_class.new(exist_page_id)
          response = page.update(record)
          response.code.should == 200
        end
      end

      context 'when page invalid' do
        it 'should raise ArgumentError error' do
          stub_valid_request_on_exists_page(:post)
          page = described_class.new(:exist_page_id)
          lambda{
            page.create(invalid_record)
          }.should raise_error(ArgumentError)
        end
      end
    end # context 'when page exists'

    context 'when page not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_page_non_exists(:put)
        page = described_class.new(non_exist_page_id)
        lambda{
          page.update(record)
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end

  end # context 'when UPDATE page'



  context 'DELETE page' do

    context 'when page exists' do
      it 'should be success' do
        stub_valid_request_on_exists_page(:delete)
        page = described_class.new(exist_page_id)
        response = page.delete
        WebMock.should have_requested(:delete, "http://www.dumbocms.com/api/v1/pages/#{exist_page_id}.json")
        response.code.should == 200
      end

      it 'should return page json object by requested id' do
        stub_valid_request_on_exists_page(:delete)
        page = described_class.new(exist_page_id)
        response = page.delete
        response.parsed_response.should == record
      end
    end # context 'when page exists'

    context 'when page not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_page_non_exists(:delete)
        page = described_class.new(non_exist_page_id)
        lambda{
          page.delete
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when page not exists'

  end # context 'when DELETE page'

end # Dumbo::API



