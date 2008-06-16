class HyperactiveToVersion41 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(41)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(40)
  end
end
