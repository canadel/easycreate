# -*- encoding : utf-8 -*-
require 'norails_spec_helper'
require File.join(APP_ROOT, "lib/external/dumbo/dumbo.rb")

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

  let(:non_exist_domain_id){ 999999 }
  let(:exist_domain_id    ){ 1      }

  def stub_valid_request_on_domain_non_exists(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/domains/#{non_exist_domain_id}.json").
           with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
           to_return(:status => 404, :body => "", :headers => {})
  end

  def stub_valid_request_on_exists_domain(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/domains/#{exist_domain_id}.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, 
                   :body => json_encode(record),
                   :headers => {"Content-Type"=>"application/json; charset=utf-8"})
  end

  def stub_valid_request_index_on_empty(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/domains.json").
           with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
           to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_valid_request_index_having_records(method = :get)
    stub_request(method, "http://www.dumbocms.com/api/v1/domains.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, 
                   :body => json_encode(records),
                   :headers => {"Content-Type"=>"application/json; charset=utf-8"})
  end

  context 'when GET index' do

    let(:records) do
     [
      {'name'     => 'pro7deals.de', 
       'page_id'  => 1, 
       'wildcard' => nil }
      ] 
    end

    specify{ described_class.should respond_to(:index) }

    it 'should make request with valid path' do
      stub_valid_request_index_on_empty
      described_class.index
      WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/domains.json")
    end

    describe 'when domains empty' do
      it 'should return empty' do
        stub_valid_request_index_on_empty
        response = described_class.index
        response.body.should be_empty
      end
    end # when domains empty

    describe 'when pages have records' do
      it 'should return json array of records' do
        stub_valid_request_index_having_records
        response = described_class.index
        response.body.should_not be_empty
        response.parsed_response.should == records
      end
    end # when domains have records

  end # context 'GET /index' 



  context 'SHOW particular domain' do

    context 'when domain exists' do
      it 'should be success' do
        stub_valid_request_on_exists_domain
        domain = described_class.new(exist_domain_id)
        response = domain.show
        WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/domains/#{exist_domain_id}.json")
        response.code.should == 200
      end

      it 'should return domain json object by requested id' do
        stub_valid_request_on_exists_domain
        domain = described_class.new(exist_domain_id)
        response = domain.show
        response.parsed_response.should == record
      end
    end # context 'when domain exists'


    context 'when domain not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_domain_non_exists
        domain = described_class.new(non_exist_domain_id)
        lambda{
          domain.show
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when domain not exists'

  end # context 'when GET particular domain'


  context 'CREATE domain' do

    context 'when domain valid' do
      it 'should return success' do
        stub_valid_request_index_on_empty(:post)
        domain = described_class.new
        response = domain.create(record)
        WebMock.should have_requested(:post, "http://www.dumbocms.com/api/v1/domains.json")
        response.code.should == 200
      end
    end

    context 'when domain invalid' do
      it 'should raise ArgumentError error' do
        stub_valid_request_index_on_empty(:post)
        domain = described_class.new
        lambda{
          domain.create(invalid_record)
        }.should raise_error(ArgumentError)
      end      
    end

  end # context 'when CREATE domain'



  context 'UPDATE domain' do

    context 'when domain exists' do
      context 'when domain valid' do
        it 'should be success' do
          stub_valid_request_on_exists_domain(:put)
          domain = described_class.new(exist_domain_id)
          response = domain.update(record)
          response.code.should == 200
        end
      end

      context 'when domain invalid' do
        it 'should raise ArgumentError error' do
          stub_valid_request_on_exists_domain(:post)
          domain = described_class.new(exist_domain_id)
          lambda{
            domain.create(invalid_record)
          }.should raise_error(ArgumentError)
        end
      end
    end # context 'when domain exists'

    context 'when domain not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_domain_non_exists(:put)
        domain = described_class.new(non_exist_domain_id)
        lambda{
          domain.update(record)
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end

  end # context 'when UPDATE domain'



  context 'DELETE domain' do

    context 'when domain exists' do
      it 'should be success' do
        stub_valid_request_on_exists_domain(:delete)
        domain = described_class.new(exist_domain_id)
        response = domain.delete
        WebMock.should have_requested(:delete, "http://www.dumbocms.com/api/v1/domains/#{exist_domain_id}.json")
        response.code.should == 200
      end

      it 'should return domain json object by requested id' do
        stub_valid_request_on_exists_domain(:delete)
        domain = described_class.new(exist_domain_id)
        response = domain.delete
        response.parsed_response.should == record
      end
    end # context 'when domain exists'

    context 'when domain not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_domain_non_exists(:delete)
        domain = described_class.new(non_exist_domain_id)
        lambda{
          domain.delete
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when domain not exists'

  end # context 'when DELETE domain'

end # Dumbo::API



