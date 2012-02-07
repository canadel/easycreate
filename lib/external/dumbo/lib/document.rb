# -*- encoding : utf-8 -*-

# The documents endpoints are:

# GET /api/v1/pages/:page_id/documents.json
# POST /api/v1/pages/:page_id/documents.json
# GET /api/v1/pages/:page_id/documents/:id.json
# PUT /api/v1/pages/:page_id/documents/:id.json
# DELETE /api/v1/pages/:page_id/documents/:id.json

module Dumbo

  class Document < Dumbo::API

    def initialize(parent_id, id=nil)
      @parent_id = parent_id
      super(id)
    end

    private
    def required_params
      []
    end

    def resource
      'documents'
    end

    def parent_resource
      'pages'
    end
    
  end # class Document

end # module Dumbo
