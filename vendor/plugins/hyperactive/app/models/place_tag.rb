class PlaceTag < ActiveRecord::Base

  has_many_polymorphs :place_taggables, 
      :from => [:events, :articles, :videos], 
      :through => :place_taggings,
      :dependent => :destroy

  def self.cloud(options={})
    query = "select place_tags.id, name, count(*) as popularity"
    query << " from place_taggings, place_tags"
    query << " where place_tags.id = place_tag_id"
    query << " and place_taggings.hide_tag = false"    
    query << " group by place_tag_id, place_tags.id, place_tags.name"
    query << " order by #{options[:order]}" if options[:order] != nil
    query << " limit #{options[:limit]}" if options[:limit] != nil
    PlaceTag.find_by_sql(query)  
  end
    
end
