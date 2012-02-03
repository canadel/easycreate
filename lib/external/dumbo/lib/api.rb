# -*- encoding : utf-8 -*-

# Generic API class for work with Dumbo endpoints
#
#

module Dumbo

  class API
    include HTTParty
    base_uri "http://www.dumbocms.com/api/v1"
    headers 'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'
    format :json
    debug_output $stdout

    # GET /index
    def self.index
      new.index
    end


    def initialize(id=nil)
      @id=id
    end

    # CRUD operations
    def index
      self.get
    end

    def show
      self.get
    end

    def create params={}
      validate_required_params(params)
      self.call(:post, params)
    end

    def update(params={})
      self.put(params)
    end

    def delete
      self.call(:delete)
    end

    protected

    def get
      self.call(:get)
    end

    def put params={}
      self.call(:put, params)
    end

    def post params={}
      validate_required_params(params)
      self.call(:post, params)
    end

    def resource
      raise NotImplementedError
    end

    def parent_resource
      raise NotImplementedError
    end

    def required_params
      raise NotImplementedError
    end

    def validate_required_params params={}
      required_params.each do |par|
        raise ArgumentError unless params.keys.include? par.to_s
      end
    end

    def id_to_slashed_string
      @id ? '/'+@id.to_s : ''
    end

    def resource_path
      path = "/#{resource}#{id_to_slashed_string}.json"
      if @parent_id
        path = "/#{parent_resource}/#{@parent_id}#{path}"
      end
      path
    end

    def call(request=:get, params={})
      retries = 3
      body = params.any? ? {body: params} : {}
      begin
        result = self.class.send(request, resource_path, body)
      rescue Timeout::Error
        if (retries -= 1) > 0
          sleep 1
          retry 
        else
          raise Timeout::Error
        end
      end

      if result.code != 200
        raise StandardError, Net::HTTPResponse::CODE_TO_OBJ[result.code.to_s]
      end
      
      result
    end

  end # class Dumbo::API

end # module Dumbo


