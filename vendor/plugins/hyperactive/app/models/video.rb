class Video < Media
  
  require_dependency 'tag'
  require_dependency 'place_tag'
  
  include DRbUndumped # allows objects of this class to be serialized and sent over the wire to the BackgrounDRb server

  WEB_ROOT = 'system/'

  upload_column :file, 
                :extensions => ["3gp",  "avi",  "m4v", "mov", "mpg", "mpeg", "mp4", "ogg", "wmv"],
                :root_dir => File.join(RAILS_ROOT, "public", "system"),
                :web_root => "/system", 
                :store_dir => proc {|record, file| 
                                      if !record.created_on.nil?
                                        return record.created_on.strftime("video/%Y/%m/%d/") +  record.id.to_s
                                      else
                                        return Date.today.strftime("video/%Y/%m/%d/") +  record.id.to_s
                                      end
                                   }
 
  validates_presence_of :title, :summary
  validates_length_of :title, :maximum=>255
  validates_presence_of :file unless RAILS_ENV == 'test'
  belongs_to :post, :foreign_key => "content_id"
  
  attr_accessor :video_type, :relative_video_file, :relative_ogg_file, :relative_torrent_file

  PROCESSING = 1
  SUCCESS = 2
  #ERROR = 3 # not used currently as I'm not sure how to trap errors.

  before_destroy :delete_files 
  before_update :delete_files
  
  # Recursively deletes all files and then the directory which the files
  # were stored in.
  #
  def delete_files
    FileUtils.remove_dir(file.store_dir)
  end 

  # TODO: I'd like to have the validates_file_format_of use this array but it 
  # returns method_missing for some reason I can't fathom.  It is being used in the
  # views already.
  #
  def self.allowed_file_types
    ["3gp",  "avi",  "m4v", "mov", "mpg", "mpeg", "mp4", "ogg", "wmv"]
  end

  # Gets an absolute path to this video's file and send it to the 
  # VideoConversionWorker for conversion.
  # 
  def convert
    video_file_to_convert = File.expand_path(RAILS_ROOT) + "/public/" + self.file.url
    MiddleMan.new_worker(:class => 
                          :video_conversion_worker, 
                          :job_key => "video"+self.object_id.to_s, 
                          :args => {
                            :absolute_path => video_file_to_convert, 
                            :torrent_tracker => TORRENT_TRACKER,
                            :video_id => self.id.to_s }) unless RAILS_ENV == 'test'
  end
  
  def video_type
    'application/ogg'
  end
  
  def relative_video_file
     self.file.url
  end

  def relative_ogg_file
    self.file.url.chomp(File.extname(self.file.url)) + ".ogg"
  end
  
  def thumbnail
    self.file.url + ".jpg"
  end
  
  def relative_torrent_file
    relative_ogg_file + ".torrent"
  end
  
  # A convenience method telling us whether this content has a thumbnail
  # which we can use in a view.  This is inherited from Content, and is
  # overridden here so that it's always true, since all video objects 
  # should have a thumbnail.
  #
  def has_thumbnail?
    true
  end
  
  # A convenience method returning the content object that this content  
  # is attached to. Currently this should only work for Video.
  # We could just use "self.content" but this method makes 
  # things hopefully a little more clear as to what's going on.
  #
  def related_content
    self.content
  end      
  
end
