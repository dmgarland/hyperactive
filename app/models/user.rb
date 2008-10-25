class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core
  
  has_many :collective_memberships
  has_many :collectives, :through => :collective_memberships

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

 # Checks permissions and ownership to see if a given user can hide a comment
  # or piece of content.
  #
  def can_hide_comment?(comment)
    return true if self.has_permission?("hide")  
    return true if self.has_permission?("hide_own_content")  && comment.content.user == self
    return false
  end
  
  def can_hide_content?(content)
    return true if self.has_permission?("hide")  
    return true if self.has_permission?("hide_own_content")  && content.user == self
    return false
  end
  
end
