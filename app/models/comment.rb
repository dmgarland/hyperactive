# A comment on a piece of Content.
#
class Comment < ActiveRecord::Base
  
  # Assocations
  #
  belongs_to :content
  
  # Validations
  #
  validates_presence_of :title, :body, :published_by
  
  # Filters
  #
  before_create :set_moderation_status_to_published
  
  # Sets the moderation status of the comment to published
  #
  def set_moderation_status_to_published
    self.moderation_status = "published"
  end
  
  # A convenience method to tell us whether this comment is currently hidden.
  #
  def is_hidden?
    self.moderation_status == "hidden"
  end
  
end
