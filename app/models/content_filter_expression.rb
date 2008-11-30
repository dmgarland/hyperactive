class ContentFilterExpression < ActiveRecord::Base
  
  include DRbUndumped # allows objects of this class to be serialized and sent over the wire to the BackgrounDRb server
  
  # Validations
  #
  validates_presence_of :regexp
  
  # Associations
  #
  belongs_to :content_filter  
  
end