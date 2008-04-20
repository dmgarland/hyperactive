class FileUpload < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :file
  validates_length_of :title, :maximum=>255
  
  file_column :file, 
              :root_path => File.join(RAILS_ROOT, "public/system"), 
              :web_root => 'system/'
              
  validates_file_format_of :file, :in => ["mp3", "ogg", "pdf", "doc", "svg", "swf", "xls", "odf", "ppt"] 
  belongs_to :post, :foreign_key => 'content_id'

end
