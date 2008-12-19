class AddEditAllGroupsPermissionToAdminRole < ActiveRecord::Migration
  def self.up
    admin = Role.find_by_title("Admin")
    p = StaticPermission.new
    p.title = "edit_all_groups"
    p.save!
    admin.static_permissions << p
  end

  def self.down
    p = StaticPermission.find_by_title("edit_all_groups")
    p.destroy
  end
end
