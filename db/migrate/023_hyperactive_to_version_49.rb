class HyperactiveToVersion49 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(49)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(48)
  end
end
