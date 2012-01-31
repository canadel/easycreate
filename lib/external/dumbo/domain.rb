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
require '../dumbo'
module Dumbo

  class Domain < Dumbo::API

    private
    def required_params
      [:name, :page_id, :wildcard]
    end

    def resource
      'domains'
    end
  end # class Domain

end # module Dumbo



if __FILE__ == $0
  require 'pp'

  domains = Dumbo::Domain.new({
                                :debug => true,
                                :credintals=>{'x-auth-key' => '7d74e4f46d6459e4ad7b78beb560c718'}})

  pp domains.index

end
