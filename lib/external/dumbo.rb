# -*- encoding : utf-8 -*-

# Generic API class for work with Dumbo endpoints
#
#
require 'httparty'
require 'pstore'

module Dumbo

	class API
    include HTTParty
    base_uri "http://www.dumbocms.com/api/v1"
    # debug_output

    attr_accessor :cookie

    def initialize(options = {})
      parse_options(options)
    end

    # CRUD operations
    def index
      self.get
    end

    def show(id)
      self.get(id)
    end

    def create params={}
      self.post(params)
    end

    def update(id, params={})
      self.put(id, params)
    end

    def delete id
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
      retries = @timeout_tryout_count
      begin
        result = self.class.send(request, resource_path(id), request_options.merge(params))
      rescue Timeout::Error
        if (retries -= 1) > 0
          sleep @timeout_tryout_pause if @timeout_tryout_pause
          retry 
        else
          raise Timeout::Error
        end
      end

      if result.code != 200
        raise StandardError, Net::HTTPResponse::CODE_TO_OBJ[result.code.to_s]
      end
      
      save_cookie(result[:headers]['set-cookie']) if @persist_cookies
      result
    end


    def request_options
      headers = if @cookie then {Cookie: @cookie} else {} end
      headers.merge! @credintals
      {:headers => headers}
    end

    #
    # options[:credintals]
    #    :x-auth-key => '7d74e4f46d6459e4ad7b78beb560c718'
    #    or {:user=>'...', :password=>'...'}
    def parse_options options
      @timeout_tryout_count = options.fetch(:tries){ 3 }
      @timeout_tryout_pause = options.fetch(:try_pause){ 1 }
      @persist_cookies      = options.fetch(:persist_cookies){ false }
      @cookie_filename      = options.fetch(:cookie_filename){ './cookie.pstore' }
      @credintals           = options[:credintals] || {}

      if @persist_cookies
        @cookie = load_cookie
      end

      if options[:debug] && options[:debug]==true
        self.class.debug_output
      end

    end

    def load_cookie
      return nil unless @persist_cookies && File.exists?(@cookie_filename)
      ps = PStore.new(@cookie_filename)
      ps.transaction(true) do
        ps[:cookie]
      end
    end

    def save_cookie cookie
      return unless @persist_cookies
      PStore.new(@cookie_filename).tap do |ps|
        ps.transaction do
          ps[:cookie] = cookie
        end
      end
    end

  end # class Dumbo::API

end # module Dumbo
