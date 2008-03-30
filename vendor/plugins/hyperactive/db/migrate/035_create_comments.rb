class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :title, :string, :null => false
      t.column :body, :text, :null => false
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
      t.column :published_by, :string, :default => "", :null => false
      t.column :moderation_status, :string, :limit => 50
      t.column :content_id, :integer, :null => false
    end
    add_index :comments, ["content_id"], :name => "fk_comments_content"
  end

  def self.down
    drop_table :comments
  end
end
