class PlaylistItemsController < ApplicationController

  # Macros
  #
  layout 'two_column'

  # Filters
  #
  before_filter :find_collective
  before_filter :can_edit?, :only => [:edit, :update, :create, :new, :index]

  # GET /playlist_items
  # GET /playlist_items.xml
  def index
    @playlist_items = @group.playlist_items

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @playlist_items }
      format.m3u  { render :m3u => @playlist_items, :layout => false }
    end
  end

  # GET /playlist_items/1
  # GET /playlist_items/1.xml
  def show
    @playlist_item = PlaylistItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @playlist_item }
    end
  end

  # GET /playlist_items/new
  # GET /playlist_items/new.xml
  def new
    @playlist_item = PlaylistItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @playlist_item }
    end
  end

  # GET /playlist@group_items/1/edit
  def edit
    @playlist_item = PlaylistItem.find(params[:id])
  end

  # POST /playlist_items
  # POST /playlist_items.xml
  def create
    @playlist_item = PlaylistItem.new(params[:playlist_item])
    @playlist_item.collective = @group

    respond_to do |format|
      if @playlist_item.save
        flash[:notice] = 'PlaylistItem was successfully created.'
        format.html { redirect_to(group_playlist_item_path(@group, @playlist_item)) }
        format.xml  { render :xml => @playlist_item, :status => :created, :location => @playlist_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @playlist_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /playlist_items/1
  # PUT /playlist_items/1.xml
  def update
    @playlist_item = PlaylistItem.find(params[:id])

    respond_to do |format|
      if @playlist_item.update_attributes(params[:playlist_item])
        flash[:notice] = 'PlaylistItem was successfully updated.'
        format.html { redirect_to(group_playlist_item_path(@group, @playlist_item)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @playlist_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_items/1
  # DELETE /playlist_items/1.xml
  def destroy
    @playlist_item = PlaylistItem.find(params[:id])
    @playlist_item.destroy

    respond_to do |format|
      format.html { redirect_to(group_playlist_items_path(@group)) }
      format.xml  { head :ok }
    end
  end

  private

  def find_collective
    @group = Collective.find(params[:group_id])
  end

  # Checks membership to see if a given user can edit this collective.
  #
  def can_edit?
    return true if current_user.is_member_of?(Collective.find(params[:group_id]))
    security_error
  end


end

