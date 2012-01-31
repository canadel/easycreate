# -*- encoding : utf-8 -*-

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
      if id
        "/#{resource}/#{id}.json"
      else
        "/#{resource}.json"
      end
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

      if options[:debug]
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

  class Pages < Dumbo::API
    private
    def required_params
      [:account_id, :name, :title, :template_id, :description, :indexable]
    end
    def resource
      'pages'
    end
  end # class Pages

  class Domains < Dumbo::API

    private
    def required_params
      [:name, :page_id, :wildcard]
    end

    def resource
      'domains'
    end
  end # class Domains

end # module Dumbo


if __FILE__ == $0
  require 'pp'

  pages = Dumbo::Pages.new({:credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}})
  domains = Dumbo::Domains.new({
                                :debug => true,
                                :credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}})

  #pp pages.index
  pp domains.show(123)

end


