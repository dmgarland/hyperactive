class PlaceTagging < ActiveRecord::Base

  belongs_to :place_tag
  belongs_to :place_taggable, :polymorphic => true

  def before_destroy
    # disallow orphaned tags
    place_tag.destroy_without_callbacks if place_tag.place_taggings.count < 2  
  end
  
end
