class Favicon < ActiveRecord::Base

  def self.save(favicon, domain)
    directory = 'public/favicons'
    path = File.join(directory, domain)
    File.open(path, 'wb') { |f| f.write(favicon.read) }
  end

end