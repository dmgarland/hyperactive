# A link in the site, can be attached to an Article, Video, or Event so that users
# can find out more info.
#
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
