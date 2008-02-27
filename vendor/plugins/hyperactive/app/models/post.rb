class Post < Content
  
  belongs_to :user
  has_many :links 

end
