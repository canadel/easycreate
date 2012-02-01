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
    #debug_output $stdout

    attr_accessor :cookie

    # GET /index
    def self.index
      new(nil).index
    end


    def initialize(id)
      @id=id
    end

    # CRUD operations
    def index
      self.get
    end

    def show(id = @id)
      self.get(id)
    end

    def create params={}
      self.post(params)
    end

    def update(id = @id, params={})
      self.put(id, params)
    end

    def delete id = @id
      self.call(:delete, id)
    end

    protected

    def get id=nil
      self.call(:get, id)
    end

    def put id, params={}
      self.call(:put, id, params)
    end

    def post params={}
      validate_required_params(params)
      self.call(:post, params)
    end

    def resource
      raise NotImplementedError
    end

    def required_params
      raise NotImplementedError
    end

    def validate_required_params params={}
      required_params.each do |par|
        raise ArgumentError unless params.keys.include? par
      end
    end

    def resource_path id=nil
      path = if id
                "/#{resource}/#{id}.json"
              else
                "/#{resource}.json"
              end
      if @parent_id
        path = "/#{parent_resource}/#{@parent_id}#{path}"
      end
      path
    end

    def call(request=:get, id=nil, params={})
      retries = 3
      begin
        result = self.class.send(request, resource_path(id), params)
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


