class AddAutoPromotionRoleAndPermission < ActiveRecord::Migration
  def self.up
    perm = StaticPermission.new
    perm.title = "auto_promote_content"
    perm.save!
    role = Role.new
    role.title = "AutoPromoted"
    role.save!
    role.static_permissions << perm

  end

  def self.down
  end
end
