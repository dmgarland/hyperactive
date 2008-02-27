class User < ActiveRecord::Base
  include ActiveRbacMixins::UserMixins::Core
  include ActiveRbacMixins::UserMixins::Validation

#  validates_format_of :email, 
#                      :with => %r{^([\w\-\.\#\$%&!?*\'=(){}|~_]+)@([0-9a-zA-Z\-\.\#\$%&!?*\'=(){}|~]+)+$},
#                      :message => 'must be a valid email address.',
#                      :allow_blank => true
end
