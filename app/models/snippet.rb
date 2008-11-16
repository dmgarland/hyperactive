# A little chunk of text that can be incorporated into the site, like for example on the
# home page.
#
class Snippet < ActiveRecord::Base
  
  # Macros
  #
  image_column  :image, 
              :versions => { :thumb => "c100x100" },
              :extensions => ["gif", "png", "jpg"],
              :root_dir => File.join(RAILS_ROOT, "public", "system"),
              :web_root => "/system"
  
  # A convenience method to tell us whether this snippet has an image.
  #
  def has_image?
    !self.image.nil?
  end
  
end
