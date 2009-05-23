class AddAdminNoteToContent < ActiveRecord::Migration
  def self.up
    change_table :content do |t|
      t.text :admin_note, :default => "", :null => false
    end
  end

  def self.down
    remove_column :content, :admin_note
  end
end
