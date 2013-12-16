class Favicon < ActiveRecord::Base

  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = 'public/favicons'
    path = File.join(directory, name)
    File.open(path, 'wb') { |f| f.write(upload['datafile'].read) }
  end

end