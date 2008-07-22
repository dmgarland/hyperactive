class Admin::SnippetsController < ApplicationController
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
        format.html { redirect_to admin_snippet_url(@snippet) }
        format.xml  { head :created, :location => admin_snippet_url(@snippet) }
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
        format.html { redirect_to admin_snippet_url(@snippet) }
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
      format.html { redirect_to admin_snippets_url }
      format.xml  { head :ok }
    end
  end
end
