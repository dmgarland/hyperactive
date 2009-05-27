# A location tag in the site, can be used to tag Content subclasses so we can see
# where they happened (for Articles and Videos) or where they will happen (Events).
#
class PlaceTag < ActiveRecord::Base

  # Associations
  #
  has_many_polymorphs :place_taggables, 
      {:from => [:events, :articles, :videos, :other_medias], 
      :through => :place_taggings,
      :dependent => :destroy}


  # Retrieves a tag cloud from the database
  #
  def self.cloud(options={})
    query = "select place_tags.id, name, count(*) as popularity"
    query << " from place_taggings, place_tags"
    query << " where place_tags.id = place_tag_id"
    query << " and place_taggings.hide_tag = 0"    
    query << " group by place_tag_id, place_tags.id, place_tags.name"
    query << " order by popularity DESC"
    query << " limit #{options[:limit]}" if options[:limit] != nil
    PlaceTag.find_by_sql(query)  
  end
    
end
