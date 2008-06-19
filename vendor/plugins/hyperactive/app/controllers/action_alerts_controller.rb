class ActionAlertsController < ApplicationController


 
  layout "two_column"

  def index
    list
    render :action => 'list'
  end

  def list
    @action_alerts = ActionAlert.find(
      :all, 
      :order => 'updated_on ASC',
      :page => {:size => objects_per_page, :current => page_param})
  end

  def show
    @action_alert = ActionAlert.find(params[:id])
  end
  
end
