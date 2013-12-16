class Favicon < ActiveRecord::Base

  def self.save(favicon)
    name = favicon.original_filename
    directory = 'public/favicons'
    path = File.join(directory, name)
    File.open(path, 'wb') { |f| f.write(favicon.read) }
  end

end