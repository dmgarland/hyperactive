# A page on the site built by admins.  
#
class Page < ActiveRecord::Base
  
  # Validations
  #
  validates_uniqueness_of :title
  validates_presence_of :title, :body
  
  # Macros
  has_friendly_id :title, :use_slug => true
  
end
