class ARecord < ActiveRecord::Base
  belongs_to  :inwx_domain
end
# == Schema Information
#
# Table name: a_records
#
#  id             :integer         not null, primary key
#  inwx_domain_id :integer
#  entry          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  name           :string(255)
#  inwx_id        :integer
#

