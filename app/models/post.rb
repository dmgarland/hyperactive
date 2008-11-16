# An Article or Event within the site.  Photos, file uploads, and videos can be added to it.
# This basically exists so that Content doesn't have these associations (which would be wrong
# in terms of the domain model), and we don't need to repeat these associations on all the 
# subclasses (currently Article and Event).
#
class Post < Content
  
  # Associations
  #
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
