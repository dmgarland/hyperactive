class HyperactiveToVersion37 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(37)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(36)
  end
end
