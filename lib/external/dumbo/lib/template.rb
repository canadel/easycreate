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
      []
    end
    def resource
      'templates'
    end
  end # class Page

end # module Dumbo

if __FILE__ == $0
  require 'pp'

  templates = Dumbo::Template.new({
                            :debug => false,
                            :credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}})

  pp templates.index.count
end


