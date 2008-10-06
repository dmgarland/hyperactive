class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core
  
  has_many :collective_memberships
  has_many :collectives, :through => :collective_memberships

  def is_collectivized?
    !self.collectives.empty?
  end
  
  def is_member_of?(collective)
    self.collectives.include?(collective)
  end

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
                          
end
