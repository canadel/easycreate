# -*- encoding : utf-8 -*-

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
require '../dumbo'
require './category'
require './document'

module Dumbo

  class Page < Dumbo::API

    def initialize(id)
      @id = id
    end

    def categories
      Dumbo::Category.new(@id).index
    end

    def documents(page_id)
      raise ArgumentError unless @options
      Dumbo::Document.new(page_id, @options)
    end

    private
    def required_params
      [:account_id, :name, :title, :template_id, :description, :indexable]
    end
    def resource
      'pages'
    end
  end # class Page

end # module Dumbo

if __FILE__ == $0
  require 'pp'

  pages = Dumbo::Page.index
  
#  pp pages

  page = Dumbo::Page.new(15)

  pp page.categories

end


