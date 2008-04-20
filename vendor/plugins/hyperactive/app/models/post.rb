class Post < Content
  
  belongs_to :user
  has_many :links
  has_many :videos, :foreign_key => "content_id"
  has_many :photos, :foreign_key => "content_id"
  has_many :file_uploads, :foreign_key => "content_id" 
  
end
