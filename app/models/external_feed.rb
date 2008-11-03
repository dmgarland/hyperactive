class ExternalFeed < ActiveRecord::Base
  
  belongs_to :collective
  
  validates_presence_of :title, :url
  validates_length_of :title, :maximum => 50
  validates_length_of :summary, :maximum => 255
  validates_uri_existence_of :url
  
  before_destroy :delete_cache_file
  
  # The location of the cached .rhtml file for this feed on disk
  #
  def cache_location
    "/public/system/cache/feeds/collectives/#{self.collective.id}/"
  end
  
  private
  
  def validate
    validate_collective_feed_length
  end
  
  # The collective that this feed is associated with should never have more
  # than 2 feeds.
  def validate_collective_feed_length
    if self.collective.external_feeds.length > 1
      self.errors.add("Group", "can't have more than two feeds.")
    end
  end
 
  # Deletes the cache file for this external feed.
  #  
  def delete_cache_file
    begin
      FileUtils.remove_dir(RAILS_ROOT + self.cache_location + "#{self.id}.rhtml")
    rescue
      nil
    end
  end
  
end
