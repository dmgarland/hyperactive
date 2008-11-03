class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core
  
  has_many :collective_memberships
  has_many :collectives, :through => :collective_memberships
  has_many :articles
  has_many :events
  has_many :videos
  
  validates_format_of     :login, 
                          :with => /^[a-zA-Z][a-zA-Z0-9_]+$/, 
                          :message => 'should consist only of letters, numbers, and underscores.'
  validates_length_of     :login, 
                          :in => 3..100, :allow_nil => true,
                          :too_long => 'must have less than 100 characters.', 
                          :too_short => 'must have more than two characters.'
  validates_length_of :password,
                      :within => 6..64,
                      :too_long => 'must have between 6 and 64 characters.',
                      :too_short => 'must have between 6 and 64 characters.',
                      :if => Proc.new { |user| user.new_password? and not user.password.nil? }

  # Does this user belongs to any collectives?
  #
  def is_collectivized?
    !self.collectives.empty?
  end
  
  # Is this user a member of a given collective?
  #
  def is_member_of?(collective)
    self.collectives.include?(collective)
  end
  
  #############################
  #     Security code         #
  #############################


  # Can the user destroy content?
  def can_destroy?(content)
    return true if self.has_permission?("destroy") 
    return false
  end

  # Checks to see if a user can edit content based on permissions, ownership, 
  # and collective membership.
  #
  def can_edit?(content)
    return true if self.has_permission?("edit_all_content")  
    return true if self.has_permission?("edit_own_content")  && content.user == self
    return true if self.collectives.include?(content.collective)
    return false
  end

  # Checks permissions and ownership to see if a given user can hide a comment.
  #
  def can_hide_comment?(comment)
    return true if self.has_permission?("hide")  
    return true if self.has_permission?("hide_own_content")  && comment.content.user == self
    return false
  end
  
  # Checks permissions and ownership to see if a given user can hide a piece of content.
  #
  def can_hide_content?(content)
    return true if self.has_permission?("hide")  
    return true if self.has_permission?("hide_own_content")  && content.user == self
    return false
  end
  
  # Checks to see if a user can unhide a piece of content.  Note that this is somewhat different from
  # the can_hide_content? check, we don't want every user to be able to unhide their own crap if somebody
  # hides it (there'd be a lot of battles between site admins and registered users if this were the case).
  # 
  def can_unhide_content?(content)
    return true if self.has_permission?("hide")  
    return false    
  end
  
  def can_feature_content?
    return true if self.has_permission?("feature_content")
    return false    
  end
  
  def can_promote_content?
    return true if self.has_permission?("promote_content")
    return false
  end
  
  def can_set_moderation_status_to?(status, content)
    return true if self.can_hide_content?(content) && status == "hidden"
    return true if self.can_promote_content? && status == "promoted"
    return true if self.can_feature_content? && status == "featured"
    return false   
  end
  
end
