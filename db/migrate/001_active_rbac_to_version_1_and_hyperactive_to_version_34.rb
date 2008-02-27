class ActiveRbacToVersion1AndHyperactiveToVersion34 < ActiveRecord::Migration
  def self.up
    Rails.plugins["active_rbac"].migrate(1)
    Rails.plugins["hyperactive"].migrate(34)
  end

  def self.down
    Rails.plugins["active_rbac"].migrate(0)
    Rails.plugins["hyperactive"].migrate(0)
  end
end
