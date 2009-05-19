# This controller provides a frontend for users to edit their data.
# Currently, only "change password" has been implemented.

class ActiveRbac::MyAccountController < ActiveRbac::ComponentController
  unloadable
  
  require_dependency 'vendor/plugins/active_rbac/app/controllers/active_rbac/my_account_controller'
  layout 'two_column'
  include CacheableUserInfo
  
  # Filters
  # 
  before_filter :protect_controller
  
  
  def index
  end

  # Allows the user to change his password. If the user is in the 
  # "retrieved_password" state then the view will display a notice
  # about the fact that the user *has* to change his password to
  # be able to proceed.
  #
  # The method checks that it's a POST request, and that the 
  # entered password equals the user's old password.
  #
  def change_password
    @user = current_user
    return if request.get?
    
    unless @user.password_equals?(params[:current_password])
      @user.errors.add_to_base('The value of current password does not match your current password.')
      return
    end
    
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.state = User.states['confirmed']
    @user.save!
    flash[:notice] = 'You have changed your password successfully.'
  end
  
  private
  
  # This controller shouldn't be accessible unless the user is logged in.
  #
  def protect_controller
    if current_user.is_anonymous?
      flash[:error] = "You are not logged in."
      redirect_to login_path
      return
    end
  end
  
end
