class Article < Post

    validates_presence_of :title, :body, :published_by
    
end
