class AddSeeAdminNotePermission < ActiveRecord::Migration
  def self.up
    see_admin_note = StaticPermission.new(:title => "see_admin_note")
    see_admin_note.save!
    
    admin = Role.find_by_title("Admin")
    admin.static_permissions << see_admin_note
    admin.save!
  end

  def self.down
  end
end
