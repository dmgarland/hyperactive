class ArticlesController < ContentController
  
  protected
  
  # We're inheriting almost all of the functionality from the ContentController
  # superclass.  This tells ContentController which model class we're dealing with.
  #
  def model_class
    Article
  end
  
end
