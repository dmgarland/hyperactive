# A relationship class joining given Tag to a Content subclass.
#
class Tagging < ActiveRecord::Base
  
  # Associations
  #
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  # Disallow orphaned tags
  #
  def before_destroy
    tag.destroy_without_callbacks if tag.taggings.count < 2  
  end
end
