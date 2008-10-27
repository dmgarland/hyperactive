# Mix in the a before filter into ActiveRbac::ComponentController to secure
# all ActiveRbac controllers.
class ActiveRbac::ComponentController < ApplicationController
  
  require_dependency 'vendor/plugins/active_rbac/app/controllers/active_rbac/component_controller'
  before_filter :protect_with_active_rbac

  include SslRequirement
  ssl_required :all 
  
  protected
  
  def protect_with_active_rbac
    # only protect certain controllers
    return true if [ActiveRbac::LoginController, ActiveRbac::RegistrationController].include?(self.class)
    # protect!
    return true if current_user.has_role? 'Admin'
    flash[:notice] = 'You have insufficient permissions!'
    redirect_to '/login'
    return false
  end

  def protect_me
  end

end
