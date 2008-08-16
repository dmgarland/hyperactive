class HyperactiveToVersion48 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(48)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(47)
  end
end
