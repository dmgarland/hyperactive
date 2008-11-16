class AddMoreDefaultModerationPermissions < ActiveRecord::Migration
  def self.up
    admin = Role.find_by_title("Admin")
    
    p = StaticPermission.new
    p.title = "promote_content"
    p.save!
    
    admin.static_permissions << p
    
    p = StaticPermission.new
    p.title = "feature_content"
    p.save!
    
    admin.static_permissions << p
  end

  def self.down
    p = StaticPermission.find_by_title("promote_content")
    p.destroy
    
    p = StaticPermission.find_by_title("feature_content")
    p.destroy
  end
end
