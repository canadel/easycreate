class InwxDomain < ActiveRecord::Base
  
  belongs_to :user
  has_many  :a_records, :dependent => :destroy
  has_many  :cname_records, :dependent => :destroy
  
  def dumbo_state
    if dumbo_binary_state
      "Dumbo activated"
    else
      "Dumbo not activated"
    end
  end
  
  def dumbo_binary_state
    if self.a_records.where(:entry => ENV['DUMBO_IP'], :name  => self.domain).exists? && self.cname_records.where(:entry => self.domain, :name => "www.#{self.domain}").exists?
      true
    else
      false
    end
  end
end