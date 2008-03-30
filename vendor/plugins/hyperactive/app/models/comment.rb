class Comment < ActiveRecord::Base
  
  belongs_to :content
  
  validates_presence_of :title, :body, :published_by
  
end
