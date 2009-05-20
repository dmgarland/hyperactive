# A link in the site, can be attached to an Article, Video, or Event so that users
# can find out more info.
#
class Link < ActiveRecord::Base
  
  # Associations
  #
  belongs_to :post
  
  # Sets up the Link object with an "http://" in the link box if it's a new link.
  #
  def after_initialize
    self.url = "http://" if self.url == ""
  end
  
  # A quick XSS check to see that the url doesn't contain any javascript shit.
  #
  def before_save
    if self.url =~ /javascript:/
      self.url = "http://ha.ckers.org/xss.html"
    end
    if self.url =~ /script:/
      self.url = "http://ha.ckers.org/xss.html"
    end
  end

end
