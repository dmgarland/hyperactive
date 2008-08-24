class CollectivesController < ApplicationController

  layout "two_column"
  
  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko safari opera},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_statusbar_location => "bottom",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :theme_advanced_resizing_use_cookie => true,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{undo redo separator bold italic underline strikethrough separator bullist numlist separator link unlink separator cleanup code},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{paste cleanup}},
              :only => [:new, :edit, :create, :update])   
  
  # GET /collectives
  # GET /collectives.xml
  def index
    @collectives = Collective.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @collectives.to_xml }
    end
  end

  # GET /collectives/1
  # GET /collectives/1.xml
  def show
    @collective = Collective.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @collective.to_xml }
    end
  end

  # GET /collectives/new
  def new
    @collective = Collective.new
  end

  # GET /collectives/1;edit
  def edit
    @collective = Collective.find(params[:id])
  end

  # POST /collectives
  # POST /collectives.xml
  def create
    @collective = Collective.new(params[:collective])

    respond_to do |format|
      if @collective.save
        flash[:notice] = 'Collective was successfully created.'
        format.html { redirect_to collective_url(@collective) }
        format.xml  { head :created, :location => collective_url(@collective) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @collective.errors.to_xml }
      end
    end
  end

  # PUT /collectives/1
  # PUT /collectives/1.xml
  def update
    @collective = Collective.find(params[:id])

    respond_to do |format|
      if @collective.update_attributes(params[:collective])
        flash[:notice] = 'Collective was successfully updated.'
        format.html { redirect_to collective_url(@collective) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @collective.errors.to_xml }
      end
    end
  end

  # DELETE /collectives/1
  # DELETE /collectives/1.xml
  def destroy
    @collective = Collective.find(params[:id])
    @collective.destroy

    respond_to do |format|
      format.html { redirect_to collectives_url }
      format.xml  { head :ok }
    end
  end
  
  def edit_memberships
    @collective = Collective.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @collective.to_xml }
    end
  end
  
  def destroy_membership
    @collective_membership = CollectiveMembership.find(params[:id])
    @collective = @collective_membership.collective
    @collective_membership.destroy
     respond_to do |format|
      format.html { redirect_to edit_collective_memberships_url(@collective) }
      format.xml  { head :ok }
    end
  end
  
  def add_membership
    @collective = Collective.find(params[:id])
    @user = User.find_by_login(params[:login])
    if @user
      @collective.users << @user 
      respond_to do |format|
        flash[:notice] = "User '#{@user.login}' was added to '#{@collective.name}'"
        format.html { redirect_to edit_collective_memberships_url }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:notice] = "User '#{params[:login]}' not found."
        format.html { redirect_to edit_collective_memberships_url }
        format.xml  { head :ok }
      end
    end
  end
  
end
