# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  # Include the ActiveRbac plugin code which runs the authentication and
  # role-based access control system
  #
  include ActiveRbacMixins::ApplicationControllerMixin  
  helper RbacHelper
  
  # Include the ExceptionNotifier plugin so we get emails if the site exploedes
  #
  include ExceptionNotifiable unless RAILS_ENV == 'test'
  
  # Include the CacheableFlash plugin. This stores the flash[:notice] and other Rails flash
  # messages in a cookie, inserting them into the page with javascript when the request
  # completes.  This way we solve a few problems:  we can still get flash[:messages] on 
  # cached pages, and we won't get the flash[:message] written into the page when the 
  # page caches upon creation - currently we are getting for example "Article was 
  # successfully created" message stuck into the cached page, which this should fix.
  # 
  include CacheableFlash unless RAILS_ENV == 'test'
  
  # For convenience, instantiate properties containing the current 
  # controller and action names on each request
  before_filter :instantiate_controller_and_action_names
  
  # Set up the click-to-globalize plugin so that we can easily do translations
  #
  # Available languages which can be clicked-to-globalize
  self.languages = { :danish => 'da-DK' } unless RAILS_ENV == 'test'
  
  # Defines who can click on text to globalize it
  def globalize?
    current_user.has_permission?("translate_ui") && RAILS_ENV != 'test'
  end
  
  # make the globalize? method available to helpers so it can be used in views
  helper_method :globalize?
  
  # The default number of content objects that get retrieved for display on list pages
  def objects_per_page
    10
  end
  
  # The default number of content objects that get retrieved for display in feeds
  def events_per_feed
    10
  end
  
  # The default number of tags to display in a cloud
  def tags_in_cloud
    50
  end
  
  # A convenience method which either grabs the page param or returns 1
  def page_param
    (params[:page] ||= 1).to_i
  end
  
  # Applies security to protected methods - only Admin users can access these.
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      security_error
    end
  end  
  
  # What do we do if someone tries to access something they're not supposed to see?
  def security_error
    redirect_to base_url
    flash[:notice] = "You are not allowed to access this page."
  end
  
  # Grabs the controller and action names so we always have those available during the lifespan of a request.
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end  
  
end