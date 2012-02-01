# -*- encoding : utf-8 -*-

# The documents endpoints are:

# GET /api/v1/pages/:page_id/documents.json
# POST /api/v1/pages/:page_id/documents.json
# GET /api/v1/pages/:page_id/documents/:id.json
# PUT /api/v1/pages/:page_id/documents/:id.json
# DELETE /api/v1/pages/:page_id/documents/:id.json

module Dumbo

  class Document < Dumbo::API

    def initialize(page_id, params={})
      @parent_id = page_id
      super(params)  
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

if __FILE__ == $0
  require 'pp'

  page_id = 1
  document = Dumbo::Document.new(
                            page_id,
                            {
                              :debug => true,
                              :credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}}
                            )

  pp document.index
end


