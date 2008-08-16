class HyperactiveToVersion47 < ActiveRecord::Migration
  def self.up
    Rails.plugins["hyperactive"].migrate(47)
  end

  def self.down
    Rails.plugins["hyperactive"].migrate(46)
  end
end
