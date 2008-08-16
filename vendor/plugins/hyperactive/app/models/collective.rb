class Collective < ActiveRecord::Base
  
  validates_length_of :name, :maximum=>255
  validates_presence_of :name, :summary

  
  image_column  :image, 
                :versions => { :thumb => "c100x100"},
                :extensions => ["gif", "png", "jpg"],
                :root_dir => File.join(RAILS_ROOT, "public", "system"),
                :web_root => "/system", 
                :store_dir => proc {|record, file| 
                                      if !record.created_on.nil?
                                        return record.created_on.strftime("group/image/%Y/%m/%d/") +  record.id.to_s
                                      else
                                        return Date.today.strftime("group/image/%Y/%m/%d/") +  record.id.to_s
                                      end
                                   }
                
  before_destroy :delete_image
  before_update :delete_image_if_new_uploaded
  
  # Recursively deletes the image and then the directory which the image
  # was stored in.
  #
  def delete_image
    FileUtils.remove_dir(image.store_dir) if File.exists?(image.store_dir)
  end 
  
  
  # Recursively deletes the image and then the directory which the image
  # was stored in, if a new image was uploaded during this request.
  #
  def delete_image_if_new_uploaded
    if !self.image.nil? && self.image.new_file?
      FileUtils.remove_dir(image.store_dir) if File.exists?(image.store_dir)
    end
  end
    
  
end