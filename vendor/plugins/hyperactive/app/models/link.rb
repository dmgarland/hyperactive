class Link < ActiveRecord::Base
  belongs_to :content
  
  def after_initialize
    self.url = "http://" if self.url == ""
  end

end
