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
  first_run Time.now

  # This method is called in it's own new thread when you
  # call new worker. args is set to :args  
  def do_work(args)
    @action_view = ActionView::Base.new(Rails::Configuration.new.view_path, {}, DummyController.new)    
    url = "http://www.indymedia.org.uk/en/promotednewswire.rss" #args[:url]
    rss = SimpleRSS.parse(open(url))
    @feed_items = rss.items[0..9]
    output = ""
    @feed_items.each do |feed_item|
      output +=  @action_view.render :partial => "feeds/external/list_title", :locals => {:list_title => feed_item}
    end
    rio(RAILS_ROOT + "/public/system/cache/uk_feed.rhtml") < output
    rio(RAILS_ROOT + "/public/system/cache/index.html").delete
  end

end


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


