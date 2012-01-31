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
module Dumbo

  class Page < Dumbo::API

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

  pages = Dumbo::Page.new({
                            :debug => true,
                            :credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}})

  pp pages.index
end


