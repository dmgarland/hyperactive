class ActionAlert < ActiveRecord::Base
  
  validates_presence_of :summary
  validates_length_of :summary, :maximum => 140
  
end
