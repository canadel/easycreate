# -*- encoding : utf-8 -*-

# The categories endpoints are:

# GET /api/v1/pages/:page_id/categories.json
# POST /api/v1/pages/:page_id/categories.json
# GET /api/v1/pages/:page_id/categories/:id.json
# PUT /api/v1/pages/:page_id/categories/:id.json
# DELETE /api/v1/pages/:page_id/categories/:id.json

module Dumbo

  class Category < Dumbo::API

    def initialize(parent_id)
      @parent_id = parent_id
      super()
    end


    private
    def required_params
      []
    end

    def resource
      'categories'
    end

    def parent_resource
      'pages'
    end
    
  end # class Category

end # module Dumbo
