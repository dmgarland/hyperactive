class Photo < ActiveRecord::Base

  validates_presence_of :file
  validates_length_of :title, :maximum=>255
  belongs_to :post, :foreign_key => 'content_id'
  
  image_column  :file, 
                :versions => { :thumb => "c100x100", :big_thumb => "180x400", :medium => "480x480" },
                :extensions => ["gif", "png", "jpg"],
                :root_dir => File.join(RAILS_ROOT, "public", "system"),
                :web_root => "/system", 
                :store_dir => proc {|record, file| 
                                      if !record.created_on.nil?
                                        return record.created_on.strftime("photo/%Y/%m/%d/") +  record.id.to_s
                                      else
                                        return Date.today.strftime("photo/%Y/%m/%d/") +  record.id.to_s
                                      end
                                   }
                
  before_destroy :delete_files 
  before_update :delete_files_if_new_uploaded
  
  # Recursively deletes all files and then the directory which the files
  # were stored in.
  #
  def delete_files
    FileUtils.remove_dir(file.store_dir) if File.exists?(file.store_dir)
  end 
  
  
  # Recursively deletes all files and then the directory which the files
  # were stored in, if a new file was uploaded during this request.
  #
  def delete_files_if_new_uploaded
    if self.file.new_file?
      FileUtils.remove_dir(file.store_dir) if File.exists?(file.store_dir)
    end
  end
  
   
end
