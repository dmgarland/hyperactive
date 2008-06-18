class HyperactiveToVersion42 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(42)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(41)
  end
end
