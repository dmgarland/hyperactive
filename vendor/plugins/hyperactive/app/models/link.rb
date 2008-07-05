class Link < ActiveRecord::Base
  belongs_to :content
  
  def after_initialize
    self.url = "http://" if self.url == ""
  end
  
  def before_save
    if self.url =~ /javascript:/
      self.url = "http://ha.ckers.org/xss.html"
    end
    if self.url =~ /script:/
      self.url = "http://ha.ckers.org/xss.html"
    end
  end

end
