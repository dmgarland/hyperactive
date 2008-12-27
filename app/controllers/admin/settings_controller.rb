class Admin::SettingsController < ApplicationController
  
  layout 'admin'
  
  # Filters
  #
  before_filter :protect_controller
  
  
  # GET /settings
  # GET /settings.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @settings }
    end
  end

  # PUT /settings/1
  # PUT /settings/1.xml
  def update
    settings = Setting.all
    settings.each do |setting|
      new_value = params[("#{setting.key}".to_sym)]
      var = setting.class.find_by_key(setting.key)
      if var.is_a?(BooleanSetting) && new_value.nil?
        new_value = false
      end
      var.send(:value=, new_value)
      Hyperactive.send("#{var.key}=", var.value)
      var.save!
    end
    flash[:notice] = 'Settings successfully updated.'
    redirect_to(admin_settings_url)
  end

  protected
  
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      security_error
    end
  end  

end
