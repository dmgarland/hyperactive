class Snippet < ActiveRecord::Base
  
  image_column  :image, 
              :versions => { :thumb => "c100x100" },
              :extensions => ["gif", "png", "jpg"],
              :root_dir => File.join(RAILS_ROOT, "public", "system"),
              :web_root => "/system"
              
  def has_image?
    !self.image.nil?
  end
  
end