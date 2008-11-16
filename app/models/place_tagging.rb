# A relationship class joining given PlaceTag to a Content subclass.
#
class PlaceTagging < ActiveRecord::Base

  # Associations
  #
  belongs_to :place_tag
  belongs_to :place_taggable, :polymorphic => true

  # Disallow orphaned tags
  def before_destroy
    place_tag.destroy_without_callbacks if place_tag.place_taggings.count < 2  
  end
  
end
