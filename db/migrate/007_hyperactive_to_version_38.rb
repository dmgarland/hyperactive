class HyperactiveToVersion38 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(38)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(37)
  end
end
