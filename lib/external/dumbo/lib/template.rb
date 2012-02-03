# -*- encoding : utf-8 -*-

# The templates endpoints are:

# GET /api/v1/templates.json
# POST /api/v1/templates.json
# GET /api/v1/templates/:id.json
# PUT /api/v1/templates/:id.json
# DELETE /api/v1/templates/:id.json


module Dumbo

  class Template < Dumbo::API

    private
    def required_params
      [:name, :account_id, :content]
    end
    def resource
      'templates'
    end
  end # class Page

end # module Dumbo

