class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_one  :inwx_credential, :dependent => :destroy
  has_many :inwx_domains, :dependent => :destroy
  
  after_create :add_emtpy_inwx_credential
  
  private
  
  def add_emtpy_inwx_credential
    self.inwx_credential = InwxCredential.new
  end
  
end