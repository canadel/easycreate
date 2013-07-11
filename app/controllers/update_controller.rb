class UpdateController < ApplicationController

  def templates

    url = URI.parse('http://www.dumbocms.com/api/packages?token=ea9da1d560bbf55b9c40ae5c01c6b95a')
    
    content = open(url).read

    packages = JSON.parse(content)

    if packages
      
      Package.destroy_all
      
      packages.each do |t|
        package = Package.new
        package.name = t['name']
        package.label = t['label']
        package.description = t['description']
        package.position = t['position']
        package.thumbnail = t['thumbnail']
        package.save
      end

    end

    render :text => 'Success'

  end

end
