class ContentFilterExpression < ActiveRecord::Base
  
  validates_presence_of :regexp
  
  belongs_to :content_filter
  
end
