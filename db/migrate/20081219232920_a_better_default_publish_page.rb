class ABetterDefaultPublishPage < ActiveRecord::Migration
  def self.up
    publish_page = Page.find("publish-page")
    if publish_page.body == "This is a default publish page.  You're going to want to edit the text of it so you can publish articles, events, and videos."
      publish_page.body = "<p>This is a default publish page.</p><p>You can:</p><ul>"
      publish_page.body += "<li><a href='/articles/new'>Publish an article</a></li>"
      publish_page.body += "<li><a href='/events/new'>Publish an event</a></li>"
      publish_page.body += "<li><a href='/videos/new'>Publish a video</a></li>"
      publish_page.body += "<li><a href='/groups/new'>Start a group</a></li>"
      publish_page.body += "</ul>"
      publish_page.save!
    end
  end

  def self.down
  end
end
