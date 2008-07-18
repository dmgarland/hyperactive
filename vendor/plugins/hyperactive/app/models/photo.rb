class Photo < ActiveRecord::Base

  validates_presence_of :file
  validates_length_of :title, :maximum=>255
  belongs_to :post, :foreign_key => 'content_id'
  
  image_column  :file, 
                :versions => { :thumb => "100x100", :big_thumb => "180x400", :medium => "480x480" },
                :extensions => ["gif", "png", "jpg"],
                :root_path => File.join(RAILS_ROOT, "public", "system"),
                :web_root => "/system"

  # A callback method which determines the path where images will be stored.  
  # Upload_column automatically uses this method to figure out the directory path to create for 
  # each uploaded image.  
  # 
  # This approach splits up image uploads by date, so that we don't put thousands of images in the same directory
  # and end up running out of file descriptors.
  #   
  def file_store_dir
    if !self.created_on.nil?
      return self.created_on.strftime("photo/%Y/%m/%d/") +  self.id.to_s
    else
      return Date.today.strftime("photo/%Y/%m/%d/") +  self.id.to_s
    end
  end
  

    
end
