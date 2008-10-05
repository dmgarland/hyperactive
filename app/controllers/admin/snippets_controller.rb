class Admin::SnippetsController < ApplicationController

  cache_sweeper :content_sweeper, :only => [:create, :update, :destroy] 
  before_filter :protect_controller
  skip_before_filter :sanitize_params
  before_filter :sanitize_params_allowing_images
  
  
  layout 'admin'
  
  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko safari opera},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_statusbar_location => "bottom",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :theme_advanced_resizing_use_cookie => true,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{undo redo separator bold italic underline strikethrough separator bullist numlist separator link unlink image separator cleanup code},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{paste cleanup}},
              :only => [:new, :edit, :create, :update, :preview])   
  
  include SslRequirement
  ssl_required :all  
  
  # GET /snippets
  # GET /snippets.xml
  def index
    @snippets = Snippet.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @snippets.to_xml }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @snippet.to_xml }
    end
  end

  # GET /snippets/new
  def new
    @snippet = Snippet.new
  end

  # GET /snippets/1;edit
  def edit
    @snippet = Snippet.find(params[:id])
  end

  # POST /snippets
  # POST /snippets.xml
  def create
    @snippet = Snippet.new(params[:snippet])

    respond_to do |format|
      if @snippet.save
        flash[:notice] = 'Snippet was successfully created.'
        format.html { redirect_to admin_snippet_path(@snippet) }
        format.xml  { head :created, :location => admin_snippet_path(@snippet) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snippet.errors.to_xml }
      end
    end
  end

  # PUT /snippets/1
  # PUT /snippets/1.xml
  def update
    @snippet = Snippet.find(params[:id])
    
    respond_to do |format|
      if @snippet.update_attributes(params[:snippet])
        flash[:notice] = 'Snippet was successfully updated.'
        format.html { redirect_to admin_snippet_path(@snippet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snippet.errors.to_xml }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.xml
  def destroy
    @snippet = Snippet.find(params[:id])
    @snippet.destroy

    respond_to do |format|
      format.html { redirect_to admin_snippets_path }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      redirect_to "/publish/list"
      flash[:notice] = "You are not allowed to access this page."
    end
  end  
  
  def sanitize_params_allowing_images
    WhiteListHelper.tags.merge("img")
    WhiteListHelper.attributes.merge("align")
    WhiteListHelper.attributes.merge("class")    
    sanitize_params
    WhiteListHelper.tags.reject!{|t| t == "img"}
    WhiteListHelper.attributes.reject!{|t| t == "align"}
    WhiteListHelper.attributes.reject!{|t| t == "class"}
  end
  
end
