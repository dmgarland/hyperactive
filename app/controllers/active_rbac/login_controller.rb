# Provides actions to log a user in and out.
#
class ActiveRbac::LoginController < ActiveRbac::ComponentController
  unloadable

  require_dependency 'vendor/plugins/active_rbac/app/controllers/active_rbac/login_controller'
  layout 'two_column'
  include CacheableUserInfo

  # If the user is anonymous, we redirect them the login page, if not we redirect
  # the user to their account page.
  #
  def index
    if current_user.is_anonymous?
      redirect_to :action => 'login'
    else
      redirect_to account_path
    end
  end

  # Displays the login form on GET and performs the login on POST. Expects the
  # Expects the "login" and "password" parameters to be set. Displays the #login
  # form on errors. The user must not be logged in.
  #
  # Checks the session entry <tt>return_to</tt> and the parameter
  # <tt>return_to</tt> for information of where to redirect to after the login
  # has been performed successfully (in this order).
  #
  # Will write the value into the <tt>return_to</tt> session parameter if it
  # came from parameter and clear it after the login has been performed
  # successfully.
  #
  # If the login is successful then the current session will be reset using
  # reset_session and all session values will be copied into a new one.
  def login
    # Check that the use is not already logged in
    unless session[:rbac_user_id].nil?
      redirect_with_notice_or_render :warning, 'You are already logged in.',
      'active_rbac/login/already_logged_in'
      return
    end

    # Set the location to redirect to in the session if it was passed in through
    # a parameter and none is stored in the session.
    if session[:return_to].nil? and !params[:return_to].nil?
      session[:return_to] = params[:return_to]
    end
    # Store the :return_to session value in an object variable so it is accessible
    # after storing the user id in the session (which will clear the session).
    @return_to = session[:return_to]

    # Simply render the login form on everything but POST.
    return unless request.method == :post

    # Handle the login request otherwise.
    @errors = Array.new

    # If login or password is missing, we can stop processing right away.
    raise ActiveRecord::RecordNotFound if params[:login].to_s.empty? or params[:password].to_s.empty?

    # Try to log the user in.
    user = User.find_with_credentials(params[:login], params[:password])

    # Check whether a user with these credentials could be found.
    raise ActiveRecord::RecordNotFound unless not user.nil?

    # Check that the user has the correct state
    raise ActiveRecord::RecordNotFound unless User.state_allows_login?(user.state)

    # Write the user into the session object.
    create_new_session(user)

    redirect_with_notice_or_default :success, 'You have logged in successfully.'
  rescue ActiveRecord::RecordNotFound
    # Add an error and let the action render normally.
    @errors << 'Invalid user name or password!'
  end

  private

  # Set a new session for the user and set the user_info cookie used by the
  # CacheableUserInfo module.
  #
  def create_new_session(user)
    @active_rbac_user = nil
    reset_session
    session[:rbac_user_id] = user.id
    write_user_info_to_cookie
  end

  # Clear the user_info cookie and wipe the user's session.
  #
  def remove_user_from_session!
    @active_rbac_user = nil
    reset_session
    destroy_user_info_cookie
  end

  # Redirects to the location stored in the <tt>@return_to</tt> property
  # and clears it if it is set or renders the template at the given path.
  # Sets <tt>flash[level]</tt> to the first parameter if it redirects.
  def redirect_with_notice_or_default(level, notice)
    if @return_to.nil?
      redirect_to account_path
    else
      flash[level] = notice
      redirect_to @return_to
    end
  end

end

