# Provides actions to log a user in and out.
#
class ActiveRbac::LoginController < ActiveRbac::ComponentController
 
  layout 'two_column'
 
  # Displays an index page which allows the user to take account-related actions
  # based on whether or not they are logged in, and their roles and permissions.
  #
  # It would be nice to turn this into the basis of a whole users and groups
  # setup, but this will do the job for now.
  # 
  # This action is necessary so that we don't need to change the main navigation
  # based on the user's role (whether they're logged in, whether they can see the admin
  # navigation, etc) - which means we can use Rails full-page caching and most of the
  # high-traffic pages on the site can be served by Apache without any (slow) 
  # database access or (slow) Ruby code execution.
  #
  # If the user is anonymous, we redirect them the login page, if not we display the
  # index template automatically.
  #
  def index
    if current_user.is_anonymous?
      redirect_to :action => 'login'
    end
  end

end