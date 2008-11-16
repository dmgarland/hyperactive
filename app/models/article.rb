# An article on the site.
#
class Article < Post

  # Validations
  #
  validates_presence_of :body
    
end
