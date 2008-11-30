# A video uploaded into the site and converted on the server.  The actual conversion happens
# in the VideoConversionWorker found in lib/workers/video_conversion_worker.rb
#
# Currently videos are automatically converted into FLV and OGG formats, and the original 
# video is also saved on the server.  A torrent file is also automatically created so that
# the video can be shared by site users.
#
class Video < Media
  
  require_dependency 'tag'
  require_dependency 'place_tag'
  
  WEB_ROOT = 'system/'

  # Macros
  #
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
  
  # Validations
  #
  validates_length_of :title, :maximum=>255
  validates_presence_of :file unless RAILS_ENV == 'test'
  
  # Assocations
  #
  belongs_to :post, :foreign_key => "content_id"
  
  # Filters
  #
  before_destroy :delete_files 
  before_update :delete_files_if_new_uploaded  
  
  # Accessors
  #
  attr_accessor :video_type, :relative_video_file, :relative_ogg_file, :relative_torrent_file

  PROCESSING = 1
  SUCCESS = 2
  #ERROR = 3 # not used currently as I'm not sure how to trap errors.
  
  # Recursively deletes all files and then the directory which the files
  # were stored in.
  #
  def delete_files
    FileUtils.remove_dir(file.store_dir)
  end 
  
  
  # Recursively deletes all files and then the directory which the files
  # were stored in, if a new file was uploaded during this request.
  #
  def delete_files_if_new_uploaded
    if self.file.new_file?
      FileUtils.remove_dir(file.store_dir)
    end
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
    unless RAILS_ENV == 'test'
      video_file_to_convert = File.expand_path(RAILS_ROOT) + "/public/" + self.file.url
      MiddleMan.new_worker(:class => 
                            :video_conversion_worker, 
                            :job_key => "video"+self.object_id.to_s, 
                            :args => {
                              :absolute_path => video_file_to_convert, 
                              :torrent_tracker => Hyperactive.torrent_tracker,
                              :video_id => self.id.to_s }) unless RAILS_ENV == 'test'
    end
  end
  
  # Currently this always return "ogg" since we only use it for inclusion in the
  # ogg-only video feed.
  #
  def video_type
    'application/ogg'
  end
  
  # The relative path to the video file.
  #
  def relative_video_file
     self.file.url
  end
  
  # The relative path to the converted ogg file for this video.
  #
  def relative_ogg_file
    self.file.url.chomp(File.extname(self.file.url)) + ".ogg"
  end
  
  # The thumbnail for this video.
  #
  def thumbnail
    self.file.url + ".jpg"
  end
  
  # The relative path to the torrent file for this video.
  #
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
