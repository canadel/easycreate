# -*- encoding : utf-8 -*-

#
# I've updated the API. Shortly, we now have a fully RESTful API for domains and pages.
#
# The domains endpoints are:
# GET /api/v1/domains.json
# POST /api/v1/domains.json
# GET /api/v1/domains/:id.json
# PUT /api/v1/domains/:id.json
# DELETE /api/v1/domains/:id.json
# POST params for http://dumbocms.com/api/v1/domains.json are:
# - name
# - page_id
# - wildcard

# The pages endpoints are:
# GET /api/v1/pages.json
# POST /api/v1/pages.json
# GET /api/v1/pages/:id.json
# PUT /api/v1/pages/:id.json
# DELETE /api/v1/pages/:id.json
# POST params for http://dumbocms.com/api/v1/pages.json are:
# - account_id
# - name
# - title
# - template_id
# - description
# - indexable


require 'httparty'
require 'pstore'


module Dumbo

	class API
    BASE = "http://www.dumbocms.com/api/v1"

    attr_accessor :base_url, :server_response, :cookie

    def initialize(base_url = Dumbo::API::BASE, options={})
      @base_url = base_url
      parse_options(options)
    end


    # helpers
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

    private

    def get id=nil
      self.call(:get, id)
    end

    def put id, params={}
      self.call(:put, id, params)
    end

    def post params={}
      self.call(:post, params)
    end

    def resource
      raise NotImplementedError
    end

    def resource_path id=nil
      if id
        "#{resource}/#{id}.json"
      else
        "#{resource}.json"
      end
    end

    def resource_url id=nil
      File.join(@base_url, resource_path(id))
    end

    def call(request=:get, id=nil, params)
      retries = @timeout_tryout_count

      begin
        result = self.class.send(request, resource_url(id), request_options.merge(params))
      rescue Timeout::Error
        if (retries -= 1) > 0
          sleep @timeout_tryout_pause if @timeout_tryout_pause
          retry 
        else
          raise Timeout::Error
        end
      end

      server_response = {
        code:    result.code, 
        message: result.message, 
        headers: result.headers
      }
      
      save_cookie(server_response[:headers]['set-cookie'])
      server_response
    end


    def request_options
      headers = if @cookie then {Cookie: @cookie} else {} end
      headers.merge @credintals
      headers
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
      @credintals           = options[:credintals]

      if @persist_cookies
        @cookie = load_cookie
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

  class Pages < Dumbo::API
    private
    def resource
      'pages'
    end
  end # class Pages

  class Domains < Dumbo::API
    private
    def resource
      'domains'
    end
  end # class Domains

end # module Dumbo




