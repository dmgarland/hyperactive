class CreateDestroyPermission < ActiveRecord::Migration
  def self.up
    destroy = StaticPermission.new
    destroy.title = "destroy"
    destroy.save!
    
    admin = Role.find_by_title("Admin")
    admin.static_permissions << [destroy]
    admin.save!
  end

  def self.down
    destroy_perm = StaticPermission.find_by_title("destroy")
    destroy_perm.destroy!
  end
end
