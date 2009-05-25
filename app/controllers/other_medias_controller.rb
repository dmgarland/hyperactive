class OtherMediasController < ContentController
  
  layout "two_column"
  
  
  # Creates a content object.  Note that all of the "initialize_xxx" stuff halfway
  # through this method refers to the sub_list plugin, which provides multiple-upload
  # capabilities for us. See that plugin's documentation to learn more.
  #
  def create
    @content = model_class.new(params[:content])
    @content.set_moderation_status(params[:content][:moderation_status], current_user) 
    @content.user = current_user if !current_user.is_anonymous?
    success = true
    success &&= !current_user.is_anonymous? || simple_captcha_valid? 
    if success && @content.save
      @content.tag_with params[:tags]
      tell_irc_channel("created")
      flash[:notice] = "#{model_class.to_s} was successfully created."
      redirect_to :action => 'show', :id => @content
    else
      @content.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)
      render :action => 'new'
    end
  end  
  
  def update
    @content = model_class.find(params[:id])
    #@content.collective_ids = [] 
    @content.update_attributes(params[:content])  
    @content.set_moderation_status(params[:content][:moderation_status], current_user)
    success = true
    success &&= @content.save    
    if success
      @content.tag_with params[:tags]
      tell_irc_channel("updated")
      flash[:notice] = "#{model_class.to_s} was successfully updated."
      redirect_to :action => 'show', :id => @content
    else
      render :action => 'edit'
    end
  end  
  
  protected
  
  # We're inheriting almost all of the functionality from the ContentController
  # superclass.  This tells ContentController which model class we're dealing with.
  #
  def model_class 
    OtherMedia
  end
end
