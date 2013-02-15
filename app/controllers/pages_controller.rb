class PagesController < ApplicationController
  
  before_filter :authenticate_user!

  def index
    @api_key = Digest::MD5.hexdigest(Digest::SHA1.hexdigest(current_user.email)[4, 25]) # MD5(SUBSTR(SHA1(email), 5, 25))
  end

end
