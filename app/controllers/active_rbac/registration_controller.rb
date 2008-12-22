# This controller provides actions for users to register with the system
# and retrieve lost passwords
class ActiveRbac::RegistrationController < ActiveRbac::ComponentController
  unloadable
  
  require_dependency 'vendor/plugins/active_rbac/app/controllers/active_rbac/registration_controller'
  layout "two_column"

  # Redirect to signup page
  def index
    redirect_to :action => 'register'
  end

  # Displays a "registration" form on GET and tries to register a user on POST.
  def register
    if request.method != :post
      # On anything but POST, we simply initialize @user with a new User object
      # for the form.
      @user = User.new
    else 
      # On POST we try to register the user.
      
      # Set password and password_confirmation into [:user] parameters
      params[:user] = Hash.new if params[:user].nil?
      params[:user][:password] = params[:password]
      params[:user][:password_confirmation] = params[:password_confirmation]

      # Execute the blocks given for the signup_fields configuration settings.
      # These will add validation functions to the User model.
      ActiveRbac.controller_registration_signup_fields.each do |field|
        field[:validation_proc].call
      end

      @user = User.new(params[:user])
      @user.password_hash_type = ActiveRbac.model_default_hash_type
      @user.state = User.states['confirmed']
      @user.roles << Role.find_by_title('Registered')
      
      if simple_captcha_valid?  && @user.save then
        render :template => 'active_rbac/registration/confirm_success'
        return
      else
        @user.errors.add_to_base(I18n.t('security.please_type_anti_spam_message')) unless (simple_captcha_valid?)
      end
    end

    # Set the additional partials to render within the form into the template
    @additional_partials = ActiveRbac.controller_registration_signup_fields.collect do |field|
      field[:template_path]
    end
  end
  
  # Confirm is empty as no email confirmation is required.
  def confirm
  end
  
  # Lostpassword is empty as there is no last password functionality.
  def lostpassword
  end

end