class CollectiveAssociation < ActiveRecord::Base
  
  belongs_to :collective
  belongs_to :collective_associatable, :polymorphic => true
  
end
