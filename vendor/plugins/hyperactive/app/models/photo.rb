class Photo < ActiveRecord::Base

  validates_presence_of :file
  validates_length_of :title, :maximum=>255
  belongs_to :post, :foreign_key => 'content_id'
  
  image_column  :file, 
                :versions => { :thumb => "100x100", :big_thumb => "180x400", :medium => "480x480" },
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
  before_update :delete_files if file.new_file?
  
  # Recursively deletes all files and then the directory which the files
  # were stored in.
  #
  def delete_files
    FileUtils.remove_dir(file.store_dir)
  end 
   
end
