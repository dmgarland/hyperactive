class CreateSnippets < ActiveRecord::Migration
  def self.up
    create_table :snippets do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
      t.column :key, :string
    end
  end

  def self.down
    drop_table :snippets
  end
end
