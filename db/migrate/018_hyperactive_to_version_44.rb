class HyperactiveToVersion44 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(44)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(43)
  end
end
