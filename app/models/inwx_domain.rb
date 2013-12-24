class InwxDomain < ActiveRecord::Base
  
  belongs_to :user
  has_many  :a_records, :dependent => :destroy
  has_many  :cname_records, :dependent => :destroy
  
  def dumbo_state

    if self.status && self.dumbo_binary_state
      "Dumbo activated"
    elsif self.status
      "Nameserves not set"
    elsif self.dumbo_binary_state
      "Dumbo not set"
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
# == Schema Information
#
# Table name: inwx_domains
#
#  id         :integer         not null, primary key
#  domain     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

