class RemoveSummaryHtmlAndBodyHtml < ActiveRecord::Migration
  def self.up
    remove_column :content, :summary_html
    remove_column :content, :body_html
  end

  def self.down
    add_column :content, :summary_html, :text
    add_column :content, :body_html, :text
  end
end
