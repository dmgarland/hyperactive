# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  include ActiveRbacMixins::ApplicationControllerMixin
  helper RbacHelper
  
  before_filter :instantiate_controller_and_action_names  
  
  def objects_per_page
    10
  end
  
  def events_per_feed
    10
  end
  
  def tags_in_cloud
    50
  end
  
  def page_param
    (params[:page] ||= 1).to_i
  end
  
  # applies security to protected methods - only Admin users can access these.
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      security_error
    end
  end  
  
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