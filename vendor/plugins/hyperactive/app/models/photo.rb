class Photo < ActiveRecord::Base
  file_column :file, 
              :magick => { 
                :versions => { "thumb" => "100x100", "medium" => "480x480>" }
              }, 
              :root_path => File.join(RAILS_ROOT, "public/system"), 
              :web_root => 'system/'
              
  validates_file_format_of :file, :in => ["gif", "png", "jpg"] 
  validates_length_of :title, :maximum=>255
  belongs_to :content
end
