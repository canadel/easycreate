class InwxCredential < ActiveRecord::Base
  
  belongs_to :user

  # validates :username, :password, :presence => true
  
end
# == Schema Information
#
# Table name: inwx_credentials
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

