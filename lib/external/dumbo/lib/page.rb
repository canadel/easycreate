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

module Dumbo

  class Page < Dumbo::API

    def categories
      Dumbo::Category.new(@id).index
    end

    def category(id)
      Dumbo::Category.new(@id, id)
    end

    def documents
      Dumbo::Document.new(@id).index
    end

    def document(id)
      Dumbo::Document.new(@id, id)
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
