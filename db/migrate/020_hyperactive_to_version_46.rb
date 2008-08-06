class HyperactiveToVersion46 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(46)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(45)
  end
end
