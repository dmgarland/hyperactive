# This is a little bit harsh.  ActiveRecord needs extensions in order to be able to do 
# tagging with has_many_polymorphs, so the simplest solution is just to put the extensions
# into ActiveRecord::Base.  This makes these methods available to any model object, which
# is less than ideal;  keep in mind that tagging won't work for a model unless that model
# is marked as being taggable in either Tag.rb or PlaceTag.rb (depending on whether you want
# the class taggable by regular category tags or by place).

# Extensions to ActiveRecord for regular Tag objects, which do categorization
#
class ActiveRecord::Base

  # Given a string of space-separated tag names,   
  # downcase them and save them to the database.
  #
  def tag_with tags
    delete_all_tags
    tags.split(" ").each do |tag|
      Tag.find_or_create_by_name(tag.downcase.gsub(",","")).taggables << self
    end
  end

  # list Tags for a model object.
  #
  def tag_list
    tags.map(&:name).join(' ')
  end
  
  # Delete a Tag for a model object.
  #
  def tag_delete tag_string
    delete_all_tags
    split = tag_string.split(" ")
    tags.delete tags.select{|t| split.include? t.name}
  end
  
  # Extensions to ActiveRecord for tag objects relating to places, i.e. PlaceTags

  # Given a string of space-separated place tag names,   
  # downcase them and save them to the database.
  #
  def place_tag_with place_tags
    delete_all_place_tags
    place_tags.split(" ").each do |tag|
      PlaceTag.find_or_create_by_name(tag.downcase.gsub(",","")).place_taggables << self
    end  
  end
  
  # List PlaceTags for a model object.
  #
  def place_tag_list
    place_tags.map(&:name).join(' ')
  end
  
  # Delete a PlaceTag for a model object.
  #
  def place_tag_delete tag_string
    split = tag_string.split(" ")
    place_tags.delete place_tags.select{|t| split.include? t.name}
  end
  
  # Delete all Tags from a model object.  
  # 
  def delete_all_tags
    taggings.each do |tagging|
      tagging.destroy
    end
    self.reload
  end
  
  # Delete all PlaceTags from a model object.
  # 
  def delete_all_place_tags
    place_taggings.each do |place_tagging|
      place_tagging.destroy
    end
    self.reload
  end

end