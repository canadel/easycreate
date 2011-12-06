class InwxDomain < ActiveRecord::Base
  
  belongs_to :user
  has_many  :a_records, :dependent => :destroy
  has_many  :cname_records, :dependent => :destroy
  
end