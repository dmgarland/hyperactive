# A pseudo-category within the site.  Although there are actually no categories for content, 
# this class allows site admins to pre-define tags which show up in the content publish
# pages of the site.  
#
class Category < ActiveRecord::Base
  
  # Validations
  #
  validates_presence_of :name, :description
  validates_length_of :name, :minimum=>3
  validates_length_of :description, :minimum=>10
  
end
