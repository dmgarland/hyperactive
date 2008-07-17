class Photo < ActiveRecord::Base

  validates_presence_of :file
  #validates_file_format_of :file, :in => ["gif", "png", "jpg"] unless RAILS_ENV == 'test'
  validates_length_of :title, :maximum=>255
  belongs_to :post, :foreign_key => 'content_id'
  
  image_column  :file, 
                :versions => { "thumb" => "100x100", "big_thumb" => "180x400", "medium" => "480x480>" },
                :root_path => File.join(RAILS_ROOT, "public/system/"),
                :extensions => ["gif", "png", "jpg"]

# eventually we'll want: 
#
#              :root_path => File.join(RAILS_ROOT, "public/system/#{self.date_path}"), 

  
  def date_path
    if self.new_record?
      return self.created_on.strftime("%Y/%m/%d") 
    else
      return Date.today.strftime("%Y/%m/%d")
    end
  end
    
end
