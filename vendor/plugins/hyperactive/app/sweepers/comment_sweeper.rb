class CommentSweeper < ActionController::Caching::Sweeper
  
  observe Comment
  
  def after_create(comment)
    expire_cache_for(comment.content)
  end
  
  def after_destroy(comment)
    expire_cache_for(comment.content)
  end
  
  def after_update(comment)
    expire_cache_for(comment.content)
  end
  
  private

  # Expire the comment's associated content show page when a comment is made.
  #
  def expire_cache_for(content)
    expire_page(:controller => content.class.to_s.downcase.pluralize, :action => 'show', :id => content.id)
  end

end
