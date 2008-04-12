class Article < Post

    validates_presence_of :title, :body, :summary, :published_by
    
end
