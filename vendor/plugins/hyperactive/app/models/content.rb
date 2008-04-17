class Content < ActiveRecord::Base
    
  set_table_name "content"
    
  acts_as_ferret({:fields => [:title, :body, :summary, :place, :published_by, :hidden, :published, :date], :remote => true } )      
  
  include HtmlPurifier
  
  before_save :save_purified_html
  
  has_many :videos
  has_many :photos
  has_many :file_uploads 
  has_many :comments
  
  has_many :published_comments, :class_name => "Comment", :conditions => "moderation_status = 'published'"
    
  # A convenience method to tell us whether this content is attached to 
  # an article or event.  Currently this should only ever return true for
  # Video, which is the only Content subtype that can be contained by
  # another piece of content. 
  #
  def has_related_content?
    self.respond_to?(:content) && !self.content.nil?
  end
  
  # A convenience method returning the content object that this content  
  # is attached to. Currently this should only work for Video.
  # We could just use "self.content" but this method makes 
  # things hopefully a little more clear as to what's going on.
  #
  def related_content
    self.content
  end    
  
  # A convenience method telling us whether this content object has any
  # videos attached to it.
  #
  def contains_videos?
    self.videos.length > 0
  end
  
  # A convenience method telling us whether this content has a thumbnail
  # which we can use in a view.
  #
  def has_thumbnail?
    self.photos.length > 0 || self.videos.length > 0
  end
  
  protected
  
  def save_purified_html
    self.summary_html = only_allow_some_html(self.summary)
  end
  

end