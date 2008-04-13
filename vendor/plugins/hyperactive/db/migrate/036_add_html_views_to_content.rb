class AddHtmlViewsToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :body_html, :text, :null => false
    add_column :content, :summary_html, :text, :null => false
  end

  def self.down
    remove_column :content, :body_html
    remove_column :content, :summary_html
  end
end
