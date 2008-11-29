# The main superclass for most of the information on the site.  Descendants include things
# like Articles, Events, Videos, etc.
#
class Content < ActiveRecord::Base
  
  set_table_name "content"

  # Filters
  #
  before_create :set_moderation_status_to_published
  after_create :run_content_filters

  # Macros
  #
  acts_as_ferret({:fields => [:title, :body, :summary, :published_by, :date]})      
  named_scope :visible, :conditions => ['moderation_status != ?', "hidden"]
  
  
  # Associations
  #
  belongs_to :user  
  belongs_to :collective
  has_many :comments
  has_many :published_comments, :class_name => "Comment", :conditions => "moderation_status = 'published'"
  
  # Validations
  #
  validates_length_of :title, :maximum => 50
  validates_presence_of :title, :summary, :published_by
  
  attr_protected :moderation_status
  
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
  
  
  def run_content_filters
    filters = ContentFilter.find(:all)
    fields_to_check = [title, body]
    fields_to_check.each do |field|
      filters.each do |filter|
        filter.content_filter_expressions.each do |filter_expression|
          if field =~ /#{filter_expression.regexp}/
            self.moderation_status = "hidden"
            self.save!
            break
          end
        end
      end
    end
  end  
  
  protected
  
  # Sets the moderation_status to published unless it's already been set, 
  # which could happen if an admin user set it during content creation.
  def set_moderation_status_to_published
    if self.moderation_status.blank?
      self.moderation_status = "published" 
    end
  end
  

    
end