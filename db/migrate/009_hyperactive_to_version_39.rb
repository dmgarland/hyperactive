class HyperactiveToVersion39 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(39)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(38)
  end
end
