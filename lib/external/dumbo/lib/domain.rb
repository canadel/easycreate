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
