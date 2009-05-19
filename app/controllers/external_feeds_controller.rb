class ExternalFeedsController < ApplicationController

  layout 'two_column'

  before_filter :find_group
  
  # Security
  before_filter :can_edit?, :only => [:edit, :update, :create, :new, :index]
  
  def index
    @external_feeds = @group.external_feeds
  end

  # GET /external_feeds/new
  # GET /external_feeds/new.xml
  def new
    @external_feed = ExternalFeed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @external_feed }
    end
  end

  # GET /external_feeds/1/edit
  def edit
    @external_feed = @group.external_feeds.find(params[:id])
  end

  # POST /external_feeds
  # POST /external_feeds.xml
  def create
    @external_feed = ExternalFeed.new(params[:external_feed])

    respond_to do |format|
      if @group.external_feeds << @external_feed
        flash[:notice] = 'ExternalFeed was successfully created.'
        format.html { redirect_to(group_external_feeds_path(@group)) }
        format.xml  { render :xml => @external_feed, :status => :created, :location => @external_feed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @external_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /external_feeds/1
  # PUT /external_feeds/1.xml
  def update
    @external_feed = @group.external_feeds.find(params[:id])
    respond_to do |format|
      if @external_feed.update_attributes(params[:external_feed])
        flash[:notice] = 'ExternalFeed was successfully updated.'
        format.html { redirect_to(group_external_feeds_path(@group)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @external_feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /external_feeds/1
  # DELETE /external_feeds/1.xml
  def destroy
    external_feed = @group.external_feeds.find(params[:id])
    external_feed.destroy

    respond_to do |format|
      format.html { redirect_to(group_external_feeds_path(@group)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_group
    @group_id = params[:group_id]
    return(redirect_to(groups_url)) unless @group_id
    @group = Collective.find(@group_id)
  end
  
  # Checks membership to see if a given user can edit this collective.
  #
  def can_edit?
    return true if current_user.is_member_of?(Collective.find(params[:group_id]))
    security_error
  end  
    
  
end
