class Admin::ContentFiltersController < ApplicationController
  
  layout "admin"   
  
  include SslRequirement
  ssl_required :all
  
  include UIEnhancements::SubList
  helper :SubList
  sub_list 'ContentFilterExpression', 'content_filter' do |content_filter_expression|
  end  

  before_filter :protect_controller
  
  # GET /content_filters
  # GET /content_filters.xml
  def index
    @content_filters = ContentFilter.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_filters }
    end
  end

  # GET /content_filters/1
  # GET /content_filters/1.xml
  def show
    @content_filter = ContentFilter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content_filter }
    end
  end

  # GET /content_filters/new
  # GET /content_filters/new.xml
  def new
    @content_filter = ContentFilter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content_filter }
    end
  end

  # GET /content_filters/1/edit
  def edit
    @content_filter = ContentFilter.find(params[:id])
  end

  # POST /content_filters
  # POST /content_filters.xml
  def create
    @content_filter = ContentFilter.new(params[:content_filter])
    success = true
    success &&= initialize_content_filter_expressions
    respond_to do |format|
      if success && @content_filter.save
        flash[:notice] = 'ContentFilter was successfully created.'
        format.html { redirect_to(admin_content_filter_url(@content_filter)) }
        format.xml  { render :xml => @content_filter, :status => :created, :location => @content_filter }
      else
        prepare_content_filter_expressions
        format.html { render :action => "new" }
        format.xml  { render :xml => @content_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /content_filters/1
  # PUT /content_filters/1.xml
  def update
    @content_filter = ContentFilter.find(params[:id])
    success = true
    success &&= initialize_content_filter_expressions
    respond_to do |format|
      if success && @content_filter.update_attributes(params[:content_filter])
        flash[:notice] = 'ContentFilter was successfully updated.'
        format.html { redirect_to(admin_content_filter_url(@content_filter)) }
        format.xml  { head :ok }
      else
        prepare_content_filter_expressions
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /content_filters/1
  # DELETE /content_filters/1.xml
  def destroy
    @content_filter = ContentFilter.find(params[:id])
    @content_filter.destroy

    respond_to do |format|
      format.html { redirect_to(admin_content_filters_url) }
      format.xml  { head :ok }
    end
  end
end
