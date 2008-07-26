class HyperactiveToVersion45 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(45)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(44)
  end
end
