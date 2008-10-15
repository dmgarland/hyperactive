class AddADefaultPublishPage < ActiveRecord::Migration
  def self.up
    page = Page.new
    page.title = "Publish Page"
    page.body = "This is a default publish page.  You're going to want to edit the text of it so you can publish articles, events, and videos."
    page.save! if Page.find_by_title("Publish Page").nil?
  end

  def self.down
  end
end
