class Tag < ActiveRecord::Base
 
  has_many_polymorphs :taggables, 
    :from => [:videos, :events, :articles], 
    :through => :taggings,
    :dependent => :destroy
      
  def self.cloud(options = {})
    query = "select tags.id, name, count(*) as popularity"
    query << " from taggings, tags"
    query << " where tags.id = tag_id"
    query << " and taggings.hide_tag = false"
    query << " group by tag_id, tags.id, tags.name"
    query << " order by popularity DESC"
    query << " limit #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
  end  
        
end