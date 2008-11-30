# A retrieval class to take care of pulling data from RSS and Atom feeds.
#
class FeedRetrievalWorker < BackgrounDRb::Rails

  # Require rss and http libraries
  require 'simple-rss'
  require 'open-uri'
  
  # The Ruby input output (rio) gem makes life easier when working with files and network streams
  require 'rio'
  
  # Including parts of Rails means we can render stuff to disk
  require 'active_support'
  require 'action_controller'
  require 'action_view'    

  repeat_every 10.minutes

  # This method is called in it's own new thread when you
  # call new worker. args is set to :args  
  def do_work(args)
    pull_uk_promoted_feed
    pull_group_feeds
  end
  
  
  private 
  
  # Pulls an RSS or Atom feed from a given url and caches it as a series of list items on disk
  # at the given cache_path.
  #
  def pull_feed(url, cache_path, cache_file)
    @action_view = ActionView::Base.new(Rails::Configuration.new.view_path, {}, DummyController.new)    
    begin
      rss = SimpleRSS.parse(open(url))
      @feed_items = rss.items[0..9]
      output = ""
      @feed_items.each do |feed_item|
        output +=  @action_view.render :partial => "feeds/external/list_title", :locals => {:list_title => feed_item}
      end  
      full_path = RAILS_ROOT + cache_path
      rio(full_path).mkpath
      rio(full_path + cache_file) < output
      rio.close
    rescue Exception => boom
      full_path = RAILS_ROOT + cache_path
      rio(full_path).mkpath
      output = "This feed failed to process: #{boom}"
      rio(full_path + cache_file) < output
      rio.close
    end
  end
  
  # Pulls the feed of promoted articles from Indymedia UK.
  #
  def pull_uk_promoted_feed
    pull_feed("http://www.indymedia.org.uk/en/promotednewswire.rss", "/public/system/cache/feeds/", "uk_feed.rhtml")
    rio(RAILS_ROOT + "/public/system/cache/index.html").delete
  end
  
  # Pulls all defined group feeds
  #
  def pull_group_feeds
    feeds = ExternalFeed.find(:all)
    feeds.each do |feed|
      pull_feed(feed.url, "#{feed.cache_location}", "#{feed.id}.rhtml")
    end
  end

end

# A faked-out Controller class which is necessary so that we can use parts of Rails
# ActionController infrastructure to render Rails views and write them to disk.
# 
class DummyController

  def logger
    @logger
  end

  def headers
    {'Content-Type' => 'application/xml'}
  end

  def response
    DummyResponse.new
  end

  def content_type
    'application/xml'
  end

end

class DummyResponse
  def content_type
    'application/xml'
  end
end


