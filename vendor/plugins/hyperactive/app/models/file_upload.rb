class FileUpload < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :file
  validates_length_of :title, :maximum=>255
  
  upload_column :file, 
              :extensions => ["mp3", "ogg", "pdf", "doc", "svg", "swf", "xls", "odf", "ppt"],
              :root_path => File.join(RAILS_ROOT, "public", "system"),
              :web_root => "/system"
              
  belongs_to :post, :foreign_key => 'content_id'

  # A callback method which determines the path where files will be stored.  
  # Upload_column automatically uses this method to figure out the directory path to create for 
  # each uploaded file.  
  # 
  # This approach splits up uploads by date, so that we don't put thousands of files in the same directory
  # and end up running out of file descriptors.
  #   
  def file_store_dir
    if !self.created_on.nil?
      return self.created_on.strftime("file_upload/%Y/%m/%d/") +  self.id.to_s
    else
      return Date.today.strftime("file_upload/%Y/%m/%d/") +  self.id.to_s
    end
  end

end
