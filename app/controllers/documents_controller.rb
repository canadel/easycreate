class DocumentsController < ApplicationController

  before_filter :authenticate_user!

end
