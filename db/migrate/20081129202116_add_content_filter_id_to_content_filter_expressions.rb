class AddContentFilterIdToContentFilterExpressions < ActiveRecord::Migration
  def self.up
    add_column :content_filter_expressions, :content_filter_id, :integer
  end

  def self.down
    remove_column :content_filter_expressions, :content_filter_id   
  end
end
