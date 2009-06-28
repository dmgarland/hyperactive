class ArticlesController < ContentController

  # Filters
  #
  before_filter :can_edit?, :only => [:photo_list, :sort_photos, :edit, :update]

  # Displays a page allowing the user to order photos for the article via
  # drag and drop.
  #
  def photo_list
    @content = Article.find(params[:id])

    respond_to do |format|
      format.html # order.rhtml
      format.iphone
      format.xml  { render :xml => @content.to_xml }
    end
  end


  # Takes an ajax request from a drag-and-drop re-ordering operation, sorts the
  # photos, and saves the list of photos in the proper order.
  #
  def sort_photos
    @content = Article.find(params[:id])
    @photos = @content.photos
    @photos.each do |photo|
      photo.position = params['photo-list'].index(photo.id.to_s) + 1
      photo.save
    end
    @content.update_attribute(:updated_on, Time.now)

    render :nothing => true
  end


  protected

  # We're inheriting almost all of the functionality from the ContentController
  # superclass.  This tells ContentController which model class we're dealing with.
  #
  def model_class
    Article
  end

end

