class PlaylistItem < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :uri
  validates_presence_of :collective


  # Associations
  #
  belongs_to :collective

end

