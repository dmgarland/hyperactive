class ContentFilterExpression < ActiveRecord::Base
  
  validates_presence_of :regexp
  
end
