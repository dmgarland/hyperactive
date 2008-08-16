class CollectiveMembership < ActiveRecord::Base
    belongs_to :collective
    belongs_to :user 
end
