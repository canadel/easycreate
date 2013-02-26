# -*- encoding : utf-8 -*-
module Dumbo

  autoload :API,      "#{Rails.root}/lib/external/dumbo/lib/api"
  autoload :Category, "#{Rails.root}/lib/external/dumbo/lib/category"
  autoload :Document, "#{Rails.root}/lib/external/dumbo/lib/document"
  autoload :Domain,   "#{Rails.root}/lib/external/dumbo/lib/domain"
  autoload :Page,     "#{Rails.root}/lib/external/dumbo/lib/page"
  autoload :Template, "#{Rails.root}/lib/external/dumbo/lib/template"

end # Dumbo
