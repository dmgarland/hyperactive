# A content filter in the site, allowing site admins to specify stuff that should be
# automatically hidden.  This system is currently incomplete.
#
class ContentFilter < ActiveRecord::Base
  
  include DRbUndumped # allows objects of this class to be serialized and sent over the wire to the BackgrounDRb server
  
  # Validations
  #
  validates_presence_of :summary, :title
  
  # Associations
  #
  has_many :content_filter_expressions, :dependent => :destroy  
  
end
