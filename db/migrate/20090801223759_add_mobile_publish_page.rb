class AddMobilePublishPage < ActiveRecord::Migration
  def self.up
    page = Page.new
    page.title = "Mobile Publish"
    page.body = "This is the mobile publish page."
    page.save!
  end

  def self.down
  end
end

