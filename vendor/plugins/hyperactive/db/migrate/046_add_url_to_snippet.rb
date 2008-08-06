class AddUrlToSnippet < ActiveRecord::Migration
  def self.up
    add_column :snippets, :url, :string
  end

  def self.down
    remove_column :snippets, :url
  end
end
