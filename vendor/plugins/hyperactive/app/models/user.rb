class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core
  include ActiveRbacMixins::UserMixins::Validation
  
  has_many :collective_memberships
  has_many :collectives, :through => :collective_memberships

#  validates_format_of :email, 
#                      :with => %r{^([\w\-\.\#\$%&!?*\'=(){}|~_]+)@([0-9a-zA-Z\-\.\#\$%&!?*\'=(){}|~]+)+$},
#                      :message => 'must be a valid email address.',
#                      :allow_blank => true
end
