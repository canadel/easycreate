# -*- encoding : utf-8 -*-


def stub_valid_request_on_resource_non_exists(method = :get)
  stub_request(method, "http://www.dumbocms.com/api/v1/#{resources}/#{non_exist_resource_id}.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 404, :body => "", :headers => {})
end

def stub_valid_request_on_exists_resource(method = :get)
  stub_request(method, "http://www.dumbocms.com/api/v1/#{resources}/#{exist_resource_id}.json").
       with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
       to_return(:status => 200, 
                 :body => json_encode(record),
                 :headers => {"Content-Type"=>"application/json; charset=utf-8"})
end

def stub_valid_request_index_on_empty(method = :get)
  stub_request(method, "http://www.dumbocms.com/api/v1/#{resources}.json").
         with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
         to_return(:status => 200, :body => "", :headers => {})
end

def stub_valid_request_index_having_records(method = :get)
  stub_request(method, "http://www.dumbocms.com/api/v1/#{resources}.json").
       with(:headers => {'X-Auth-Key'=>'7d74e4f46d6459e4ad7b78beb560c718'}).
       to_return(:status => 200, 
                 :body => json_encode(records),
                 :headers => {"Content-Type"=>"application/json; charset=utf-8"})
end

shared_examples_for "index" do
  context 'when GET index' do

    specify{ described_class.should respond_to(:index) }

    it 'should make request with valid path' do
      stub_valid_request_index_on_empty
      described_class.index
      WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/#{resources}.json")
    end

    describe "when resources empty" do
      it 'should return empty' do
        stub_valid_request_index_on_empty
        response = described_class.index
        response.body.should be_empty
      end
    end # when resources empty

    describe "when resources have records" do
      it 'should return json array of records' do
        stub_valid_request_index_having_records
        response = described_class.index
        response.body.should_not be_empty
        response.parsed_response.should == records
      end
    end # when resources have records

  end # context 'GET /index' 
end


shared_examples_for "show" do
  context "SHOW particular resource" do

    context "when resource exists" do
      it 'should be success' do
        stub_valid_request_on_exists_resource
        res = described_class.new(exist_resource_id)
        response = res.show
        WebMock.should have_requested(:get, "http://www.dumbocms.com/api/v1/#{resources}/#{exist_resource_id}.json")
        response.code.should == 200
      end

      it "should return resource json object by requested id" do
        stub_valid_request_on_exists_resource
        res = described_class.new(exist_resource_id)
        response = res.show
        response.parsed_response.should == record
      end
    end # context 'when resource exists'


    context "when resource not exists" do
      it 'should raise NotFound error' do
        stub_valid_request_on_resource_non_exists
        res = described_class.new(non_exist_resource_id)
        lambda{
          res.show
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when resource not exists'

  end # context 'when SHOW particular resource'
end

shared_examples_for "create" do
  context "CREATE resource" do

    context "when resource valid" do
      it 'should return success' do
        stub_valid_request_index_on_empty(:post)
        res = described_class.new
        response = res.create(record)
        WebMock.should have_requested(:post, "http://www.dumbocms.com/api/v1/#{resources}.json")
        response.code.should == 200
      end
    end

    context "when resource invalid" do
      it 'should raise ArgumentError error' do
        stub_valid_request_index_on_empty(:post)
        res = described_class.new
        lambda{
          res.create(invalid_record)
        }.should raise_error(ArgumentError)
      end      
    end

  end # context 'when CREATE resource'
end


shared_examples_for "update" do
  context 'UPDATE resource' do

    context 'when resource exists' do
      context 'when resource valid' do
        it 'should be success' do
          stub_valid_request_on_exists_resource(:put)
          res = described_class.new(exist_resource_id)
          response = res.update(record)
          response.code.should == 200
        end
      end

      context 'when resource invalid' do
        it 'should raise ArgumentError error' do
          stub_valid_request_on_exists_resource(:post)
          domain = described_class.new(exist_resource_id)
          lambda{
            domain.create(invalid_record)
          }.should raise_error(ArgumentError)
        end
      end
    end # context 'when resource exists'

    context 'when resource not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_resource_non_exists(:put)
        res = described_class.new(non_exist_resource_id)
        lambda{
          res.update(record)
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end

  end # context 'when UPDATE resource'
end


shared_examples_for "delete" do
  context 'DELETE resource' do

    context 'when resource exists' do
      it 'should be success' do
        stub_valid_request_on_exists_resource(:delete)
        res = described_class.new(exist_resource_id)
        response = res.delete
        WebMock.should have_requested(:delete, "http://www.dumbocms.com/api/v1/#{resources}/#{exist_resource_id}.json")
        response.code.should == 200
      end

      it 'should return resource json object by requested id' do
        stub_valid_request_on_exists_resource(:delete)
        res = described_class.new(exist_resource_id)
        response = res.delete
        response.parsed_response.should == record
      end
    end # context 'when resource exists'

    context 'when resource not exists' do
      it 'should raise NotFound error' do
        stub_valid_request_on_resource_non_exists(:delete)
        res = described_class.new(non_exist_resource_id)
        lambda{
          res.delete
        }.should raise_error(StandardError, 'Net::HTTPNotFound')
      end
    end # context 'when resource not exists'

  end # context 'when DELETE resource'
end