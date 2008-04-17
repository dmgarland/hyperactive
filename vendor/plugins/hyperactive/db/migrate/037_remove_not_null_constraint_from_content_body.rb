class RemoveNotNullConstraintFromContentBody < ActiveRecord::Migration
  def self.up
    change_column :content, :body_html, :text, :null => true
  end

  def self.down
    change_column :content, :body_html, :text, :null => false
  end
end
