class InwxDomain < ActiveRecord::Base
  
  belongs_to :user
  has_many  :a_records
  has_many  :cname_records
  
end
