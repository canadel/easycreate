module ApplicationHelper

  def api_token
    Digest::MD5.hexdigest(Digest::SHA1.hexdigest(current_user.email)[4, 25]) # MD5(SUBSTR(SHA1(email), 5, 25))
  end

  def api_base
    'http://dumbocms.com/api'
  end

  def api_url(resource, id = nil)
    result = api_base + '/' + resource
    result += '/' + id unless id.nil?
    result
  end

  def api_params
    result = 'token=' + api_token + '&callback=?'
  end

end
