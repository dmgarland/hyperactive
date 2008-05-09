class AddHideOwnContentPermission < ActiveRecord::Migration
  def self.up
    hide_own_content = StaticPermission.new
    hide_own_content.title = "hide_own_content"
    hide_own_content.save!
    
    registered = Role.find_by_title("Registered")
    registered.static_permissions << hide_own_content
    registered.save!
    
    hider = Role.find_by_title("Hider")
    hider.static_permissions << hide_own_content
    hider.save!
    
    admin = Role.find_by_title("Admin")
    admin.static_permissions << hide_own_content
    admin.save!
  end

  def self.down
    hide = StaticPermission.find_by_title("hide_own_content")
    hide.destroy
  end
end
