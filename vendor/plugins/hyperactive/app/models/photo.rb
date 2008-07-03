class Photo < ActiveRecord::Base
  file_column :file, 
              :magick => { 
                :versions => { "thumb" => "100x100", "big_thumb" => "180x400", "medium" => "480x480>" }
              }, 
              :root_path => File.join(RAILS_ROOT, "public/system"), 
              :web_root => 'system/'
  
  validates_presence_of :file
  validates_file_format_of :file, :in => ["gif", "png", "jpg"] unless RAILS_ENV == 'test'
  validates_length_of :title, :maximum=>255
  belongs_to :post, :foreign_key => 'content_id'
end
