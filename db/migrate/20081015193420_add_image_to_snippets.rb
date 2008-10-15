class AddImageToSnippets < ActiveRecord::Migration
  def self.up
    add_column :snippets, :image, :string
  end

  def self.down
    remove_column :snippets, :image
  end
end
