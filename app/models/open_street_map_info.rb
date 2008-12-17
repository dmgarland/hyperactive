class OpenStreetMapInfo < ActiveRecord::Base
  
  # Validations
  #
  validates_presence_of :lat, :lng, :zoom
  
  # Associations
  # 
  belongs_to :content
  
end
