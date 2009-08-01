# This is the superclass for all controllers in this application.  All
# controllers have access to any public or protected method in here.
#
class ApplicationController < ActionController::Base

  # The default mobile subdomain is :mob, if the site is accessed through
  # that subdomain then it'll show up with mobile templates.
  #
  acts_as_mobified_controller :subdomain => Hyperactive.mobile_subdomain

  # Filter parameter logging so we don't log people's passwords
  #
  filter_parameter_logging :password

  # TODO: enable this.
  #
  #  helper :all
  #  protect_from_forgery :secret => '83c8a9e668d98a650e444d7f72d44dff'

  include CacheableUserInfo
  before_filter :write_user_info

  # Writes the user info (from the session) into a cookie so that it can be
  # picked up by the javascript and written into the page - i.e.
  # "You are currently logged in as *foo*. This allows us to use full-page
  # caching but still customize the page a bit for the user, so we can serve
  # static HTML pages directly from Apache without hitting Rails at all.
  #
  def write_user_info
    write_user_info_to_cookie
  end


  # Because we're deployed on mod_rails and also have mod_removeip installed
  # on the server, Rails thinks that all requests are local (since mod_rails
  # is getting its request from 127.0.0.1 and there is no remote_ip.
  # This means our normal configuration setup for a production Rails app
  # doesn't quite work and we're *always* showing stack traces on errors.
  # This snippet of code fixes it.
  #
  # See
  # http://thebalance.metautonomo.us/2008/05/30/the-local_request-that-isnt/
  # for a longer explanation.
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

  # Include the ApplicationHelper so we can use it in our controllers.
  #
  include ApplicationHelper
  helper ApplicationHelper

  # Include the ExceptionNotifier plugin so we get emails if the site explodes
  #
  include ExceptionNotifiable unless RAILS_ENV == 'test'

  # Include the CacheableFlash plugin. This stores the flash[:notice] and other
  # Rails flash messages in a cookie, inserting them into the page with
  # javascript when the request completes.  This way we solve a few problems:
  # we can still get flash[:messages] on cached pages, and we won't get the
  # flash[:message] written into the page when the page caches upon creation
  # - currently we are getting for example "Article was successfully created"
  # message stuck into the cached page, which this should fix.
  #
  include CacheableFlash unless RAILS_ENV == 'test'

  # For convenience, instantiate properties containing the current
  # controller and action names on each request
  #
  before_filter :instantiate_controller_and_action_names

  # Include the SSL requirement plugin and allow any action to be accessed as
  # SSL.
  #
  include SslRequirement
  ssl_allowed :all

  # Turn off the SSL requirement when not in production mode, so we can
  # continue to develop and test using Mongrel or Webrick or whatever.
  #
  alias :original_ssl_required? :ssl_required?
  def ssl_required?
    Hyperactive.use_ssl && original_ssl_required? &&
    (RAILS_ENV == "production" || RAILS_ENV == "staging")
  end

  # The default number of content objects that get retrieved for display on
  # list pages.
  #
  def objects_per_page
    10
  end

  # The default number of content objects that get retrieved for display in
  # feeds.
  #
  def events_per_feed
    10
  end

  # The default number of tags to display in a cloud
  #
  def tags_in_cloud
    20
  end

  # A convenience method which either grabs the page param or returns 1
  #
  def page_param
    (params[:page] ||= 1).to_i
  end

  # Applies security to protected methods - only Admin users can access these.
  #
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      security_error
    end
  end

  # What do we do if someone tries to access something they're not supposed
  # to see?
  #
  def security_error
    if current_user.is_anonymous?
      store_uri_in_session
      redirect_to login_path
      flash[:error] = I18n.t('security.login_necessary')
    else
      redirect_to root_path
      flash[:error] = I18n.t('security.permissions_error')
    end
  end

  # Grabs the controller and action names so we always have those available
  # during the lifespan of a request.
  #
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end

  def notify_irc_channel(message)
    begin
      MiddleMan.get_worker(:irc_bot).notify_irc_channel(message)
    rescue
      # we could do something here if we really wanted to ensure everbody ran
      # an irc bot all the time, but there's probably very little point in
      # doing so.
    end
  end

  # Store the URI of the current request in the session.
  #
  def store_uri_in_session
    session[:return_to] = request.request_uri unless !session[:return_to].nil?
  end

end

