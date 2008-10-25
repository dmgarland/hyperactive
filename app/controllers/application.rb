# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
# TODO: enable this.
#  
#  helper :all
#  protect_from_forgery :secret => '83c8a9e668d98a650e444d7f72d44dff'


  # Because we're deployed on mod_rails and also have mod_removeip installed on the server, Rails thinks that 
  # all requests are local (since mod_rails is getting its request from 127.0.0.1 and there is no remote_ip.
  # This means our normal configuration setup for a production Rails app doesn't quite work and we're *always*
  # showing stack traces on errors.  This snippet of code fixes it. 
  # 
  # See http://thebalance.metautonomo.us/2008/05/30/the-local_request-that-isnt/ for a longer explanation.
  # 
  def local_request?
    false
  end
  
  # Sanitize any parameters submitted via forms before doing anything else
  # I am thinking that this could eventually be moved into a less global place, 
  # like maybe into the ContentController on specific actions, but let's put it
  # here for now while it's being tried out.
  # 
  before_filter :sanitize_params
  
  # Include the ActiveRbac plugin code which runs the authentication and
  # role-based access control system
  #
  include ActiveRbacMixins::ApplicationControllerMixin  
  helper RbacHelper
  
  # Include the ExceptionNotifier plugin so we get emails if the site explodes
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
  
  # Include the SSL requirement plugin and allow any action to be accessed as SSL.
  # 
  include SslRequirement
  ssl_allowed :all

  # Turn off the SSL requirement when not in production mode, so we can continue
  # to develop and test using Mongrel or Webrick or whatever.
  #
  alias :original_ssl_required? :ssl_required?
  def ssl_required?
    Hyperactive.use_ssl && original_ssl_required? && (RAILS_ENV == "production" || RAILS_ENV == "staging")
  end       
  
  # Set up the click-to-globalize plugin so that we can easily do translations
  #
  # Available languages which can be clicked-to-globalize
  #
  # TODO 2.1 : the old click to globalize plugin screws up in Rails 2.1, 
  # it needs an upgrade.  Replace it with the newer one and re-enable this code.
  #self.languages = { :danish => 'da-DK' } unless RAILS_ENV == 'test'
  
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
    20
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
    redirect_to root_path
    flash[:notice] = "You are not allowed to access this page."
  end
  
  # Grabs the controller and action names so we always have those available during the lifespan of a request.
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end  
    
end