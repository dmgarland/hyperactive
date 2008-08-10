class Article < Post

  validates_presence_of :body

  def save_purified_html
    super
    self.body_html = only_allow_some_html(self.body)
  end
    
end
