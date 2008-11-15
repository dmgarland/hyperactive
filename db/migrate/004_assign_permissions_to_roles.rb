class AssignPermissionsToRoles < ActiveRecord::Migration
  def self.up
    hide = StaticPermission.new
    hide.title = "hide"
    hide.save!
    
    edit_own_content = StaticPermission.new
    edit_own_content.title = "edit_own_content"
    edit_own_content.save!
    
    edit_all_content = StaticPermission.new
    edit_all_content.title = "edit_all_content"
    edit_all_content.save!
    
    see_admin_nav = StaticPermission.new
    see_admin_nav.title = "see_admin_nav"
    see_admin_nav.save
    
    admin = Role.find_by_title("Admin")
    admin.static_permissions << [hide, see_admin_nav, edit_all_content]
    admin.save!
    
    registered = Role.new
    registered.title = "Registered"
    registered.static_permissions << [edit_own_content]
    registered.save!
    
    hider = Role.new
    hider.title = "Hider"
    hider.parent = registered
    hider.static_permissions << [hide]
    hider.save!
    
  end

  def self.down
    
  end
end
