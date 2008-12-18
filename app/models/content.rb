# The main superclass for most of the information on the site.  Descendants include things
# like Articles, Events, Videos, etc.
#
class Content < ActiveRecord::Base

  include DRbUndumped # allows objects of this class to be serialized and sent over the wire to the BackgrounDRb server
  set_table_name "content"  

  # Filters
  #
  before_create :set_moderation_status_to_published
  before_save :set_collective_moderation_status

  # Macros
  #
  acts_as_xapian :texts => [:title, :body, :summary, :published_by, :date, :moderation_status]
  named_scope :visible, :conditions => ['moderation_status != ?', "hidden"]
  named_scope :promoted, :conditions => ['moderation_status = ?', "promoted"]
  named_scope :promoted_and_featured, :conditions => ['moderation_status = ? OR moderation_status = ?', "promoted", "featured"]
  
  # Associations
  #
  belongs_to :user  
  belongs_to :collective
  has_many :comments, :dependent => :destroy
  has_many :published_comments, :class_name => "Comment", :conditions => "moderation_status = 'published'"
  has_one :open_street_map_info, :dependent => :destroy
  
  # Validations
  #
  validates_length_of :title, :maximum => 50
  validates_presence_of :title, :summary, :published_by
  
  # Association Proxies
  def self.find_with_xapian(search_term, options={:limit => 20})
    result = ActsAsXapian::Search.new([self], search_term + " NOT moderation_status:hidden", options).results.collect{|x| x[:model]}
    result = nil if result.is_a?(Array) && result.first == nil
  end
  
  
  attr_protected :moderation_status
  
  def set_collective_moderation_status
    unless self.collective.nil?
      self.collective.moderation_status = 'recently_updated'
      self.collective.save!
    end
  end
  
  # A convenience method to tell us whether this content is attached to 
  # an article or event.  Currently this should only ever return true for
  # Video, which is the only Content subtype that can be contained by
  # another piece of content. 
  #
  def has_related_content?
    self.respond_to?(:content) && !self.content.nil?
  end
  
      
  # Returns true if this content has at least one comment.
  def has_comments?
    self.comments.length > 0
  end
  
  # Returns true if this content allows comments.
  #
  def allows_comments?
    self.allows_comments && self.is_not_hidden?
  end
  
  # A convenience method telling us whether this content has a thumbnail
  # which we can use in a view.
  #
  def has_thumbnail?
    self.photos.length > 0 || self.videos.length > 0
  end
  
  # Returns true if this content is hidden.
  #
  def is_hidden?
    self.moderation_status == "hidden"  
  end

  # Returns true if this content is published.
  #
  def is_published?
    self.moderation_status == "published"
  end
  
  # Returns true if this content is promoted.
  #
  def is_promoted?
    self.moderation_status == "promoted"
  end
  
  # Returns true if this content is not hidden.
  #
  def is_not_hidden?
    self.moderation_status != "hidden"
  end
  
  # Does this content belong to a collective?
  #
  def is_collectivized?
    !self.collective.nil?
  end
  
  # Does this content have map info associated with it?
  #
  def has_map_info?
    !self.open_street_map_info.nil?
  end

#  This doesn't do anything yet but might when we move towards getting the 
#  content archives cacheable.
#  
#  def date_path
#    self.created_on.strftime("%Y/%m/%d")
#  end
  
  # Checks to see that the user submitting the content has the proper permission to change the moderation
  # status (if one has been submitted). 
  #
  def set_moderation_status(status, user)
    unless status.nil?
      self.moderation_status = status if user.can_set_moderation_status_to?(status, self)
    end
  end
  
  protected
  
  # Sets the moderation_status to published unless it's already been set, 
  # which could happen if an admin user set it during content creation.
  #
  def set_moderation_status_to_published
    if self.moderation_status.blank?
      self.moderation_status = "published" 
    end
  end
    
end