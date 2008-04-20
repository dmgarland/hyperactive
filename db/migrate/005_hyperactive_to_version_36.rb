class HyperactiveToVersion36 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(36)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(35)
  end
end
