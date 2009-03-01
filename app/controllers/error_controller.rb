# Rails freaks out if it gets a URL for which there's no possible route.
# The index action of this class displays a 404 in such cases.
#
class ErrorController < ApplicationController
  
  def index
    render :file => "#{Rails.public_path}/404.html"
  end

end
