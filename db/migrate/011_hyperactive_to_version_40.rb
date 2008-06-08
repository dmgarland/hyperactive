class HyperactiveToVersion40 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(40)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(39)
  end
end
