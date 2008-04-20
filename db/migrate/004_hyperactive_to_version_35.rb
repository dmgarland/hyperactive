class HyperactiveToVersion35 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(35)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(34)
  end
end
