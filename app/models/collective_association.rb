# An association between a Collective (group) and a piece of content.
# This class is currently not in use; it was being used to allow "has and belongs to many"
# relationships between Content and Collectives, but the site has been changed so that
# each piece of content can only belong to one Collective.  
#
# However, we think that this class could come back into use if we want 
# to allow Collectives to have something like a "we think this is cool" 
# newswire (or events list).  In that case, it would be necessary to go with this 
# kind of relationship, so we'll keep the class code around.
#
class CollectiveAssociation < ActiveRecord::Base
  
  belongs_to :collective
  belongs_to :collective_associatable, :polymorphic => true
  
end
