class ExternalFeed < ActiveRecord::Base
  
  belongs_to :collective
  
  validates_presence_of :title, :url
  validates_length_of :title, :maximum => 50
  validates_length_of :summary, :maximum => 50
  
  before_destroy :delete_cache_file
  
  # The location of the cached .rhtml file for this feed on disk
  #
  def cache_location
    "/public/system/cache/feeds/collectives/#{self.collective.id}/"
  end
  
  private
 
  # Deletes the cache file for this external feed.
  #  
  def delete_cache_file
    FileUtils.remove_dir(RAILS_ROOT + self.cache_location + "#{self.id}.rhtml")
  end
  
end
