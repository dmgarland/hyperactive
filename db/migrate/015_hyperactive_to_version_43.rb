class HyperactiveToVersion43 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(43)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(42)
  end
end
