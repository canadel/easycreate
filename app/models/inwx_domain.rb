class InwxDomain < ActiveRecord::Base
  
  belongs_to :user
  has_many  :a_records, :dependent => :destroy
  has_many  :cname_records, :dependent => :destroy
  
  def dumbo_state
    if self.a_records.where(:entry => "184.106.177.132").exists? && self.cname_records.where(:entry => self.domain, :name => "www")
      "Dumbo activated"
    else
      "Dumbo not activated"
    end
  end
  
  def dumbo_binary_state
    if self.a_records.where(:entry => "184.106.177.132").exists? && self.cname_records.where(:entry => self.domain, :name => "www")
      true
    else
      false
    end
  end
end