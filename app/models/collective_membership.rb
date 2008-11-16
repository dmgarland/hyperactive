# Defines a relationship between a Collective (group) and a User.
#
class CollectiveMembership < ActiveRecord::Base
    belongs_to :collective
    belongs_to :user 
end
