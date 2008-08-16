class CollectivesController < ApplicationController
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
end
