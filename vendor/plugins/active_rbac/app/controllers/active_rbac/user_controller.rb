# This is the controller that provides CRUD functionality for the User model.
class ActiveRbac::UserController < ActiveRbac::ComponentController
  unloadable
  
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper

  # Use the configured layout.
  layout ActiveRbac.controller_layout

  # Simply redirects to #list
  def index
    redirect_to :action  => 'list'
  end

  # Displays a paginated table of users.
  def list
    @users = User.paginate :page => (params[:page] ||=1), :per_page => 20
  end

  # Show a user identified by the +:id+ path fragment in the URL.
  def show
    @user = User.find(params[:id].to_i)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'This user could not be found.'
    redirect_to :action => 'list'
  end

  # Display a form to create a new user on GET. Handle the form submission 
  # from this form on POST and display errors if there were any.
  def create
    if request.get?
      @user = User.new
    else
      # set password and password_confirmation into [:user] parameters
      params[:user][:password] = params[:password]
      params[:user][:password_confirmation] = params[:password_confirmation]
    
      @user = User.new(params[:user])

      # set password hash type seperatedly because it is protected
      @user.password_hash_type = params[:user][:password_hash_type]
    
      # assign properties to user
      if @user.save
        # set the user's roles to the roles from the parameters 
        params[:user][:roles] = [] if params[:user][:roles].nil?
        @user.roles = params[:user][:roles].collect { |i| Role.find(i) }

        # set the user's groups to the groups from the parameters 
        params[:user][:groups] = [] if params[:user][:groups].nil?
        @user.groups = params[:user][:groups].collect { |i| Group.find(i) }

        # the above should be successful if we reach here; otherwise we 
        # have an exception and reach the rescue block below
        flash[:success] = 'User was created successfully.'
        redirect_to :action => 'show', :id => @user.to_param
      else
        render :action => 'create'
      end
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to :action => 'list'
  end

  # Display a form to edit the given user on GET. Handle the form submission
  # of this form on POST and display errors if any occured.
  def update
    @user = User.find(params[:id])
    
    if request.get?
      # render only
    else
      # get an array of roles and set the role associations
      params[:user][:roles] = [] if params[:user][:roles].nil?
      roles = params[:user][:roles].collect { |i| Role.find(i) }
      @user.roles = roles

      # get an array of groups and set the group associations
      params[:user][:groups] = [] if params[:user][:groups].nil?
      groups = params[:user][:groups].collect { |i| Group.find(i) }
      @user.groups = groups

      # Set password and password_confirmation into [:user] parameters
      unless params[:password].to_s == ""
        params[:user][:password] = params[:password]
        params[:user][:password_confirmation] = params[:password_confirmation]
      end

      # Set password hash type seperatedly because it is protected
      @user.password_hash_type = params[:user][:password_hash_type] if params[:user][:password_hash_type] != @user.password_hash_type

      # Bulk-Assign the other attributes from the form.
      if @user.update_attributes(params[:user])
        flash[:success] = 'User was successfully updated.'
        redirect_to :action => 'show', :id => @user.to_param
      else
        render :action => 'update'
      end
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'You sent an invalid request.'
    redirect_to :action => 'list'
  end
  
  # Display a confirmation form (which asks "do you really want to delete this
  # user?") on GET. Handle the form submission on POST. Redirect to the "list"
  # action if the user has been deleted and redirect to the "show" action with
  # these user's id if it has not been deleted.
  def delete
    @user = User.find(params[:id])
    
    if request.get?
      # render only
    else
      if not params[:yes].nil?
        @user.destroy
        flash[:success] = 'The user has been deleted successfully'
        redirect_to :action => 'list'
      else
        flash[:success] = 'The user has not been deleted.'
        redirect_to :action => 'show', :id => params[:id]
      end
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'This user could not be found.'
    redirect_to :action => 'list'
  end
end
