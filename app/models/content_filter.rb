# A content filter in the site, allowing site admins to specify stuff that should be
# automatically hidden.  This system is currently incomplete.
#
class ContentFilter < ActiveRecord::Base
  
  validates_presence_of :summary, :title
  
  has_many :content_filter_expressions
  
end
