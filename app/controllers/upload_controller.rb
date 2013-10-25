class UploadController < ApplicationController

  protect_from_forgery :except => :image 

  def image
    if params[:file]
      uploaded_io = params[:file]
      fileName = Time.now.to_i.to_s + '_' + uploaded_io.original_filename
      path = Rails.root.join('public', 'uploads', fileName)
      
      File.open(path, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      render :json => { :filelink => 'http://easycreate.dumbocms.com/uploads/' + fileName }
    else
      render :text => 'Error', :status => 500
    end
  end

end
