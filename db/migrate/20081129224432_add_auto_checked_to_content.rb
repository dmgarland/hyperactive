class AddAutoCheckedToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :auto_moderation_checked, :boolean, :default => false
    content = Content.find(:all)
    content.each do |c|
      c.auto_moderation_checked = true
      c.save!
    end
  end

  def self.down
    remove_column :content, :auto_moderation_checked
  end
end