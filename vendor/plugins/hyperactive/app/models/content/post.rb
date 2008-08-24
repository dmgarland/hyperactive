class Post < Content
  
  belongs_to :user
  has_many :links
  has_many :videos, :foreign_key => "content_id"
  has_many :photos, :foreign_key => "content_id"
  has_many :file_uploads, :foreign_key => "content_id" 
  
  # A convenience method telling us whether this content object has any
  # videos attached to it.
  #
  def contains_videos?
    self.videos.length > 0
  end
  
end
