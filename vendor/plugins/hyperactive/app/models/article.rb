class Article < Post

  validates_presence_of :title, :body, :summary, :published_by

  def save_purified_html
    super
    self.body_html = only_allow_some_html(self.body)
  end
    
end
