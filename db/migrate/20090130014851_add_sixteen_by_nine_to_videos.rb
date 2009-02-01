class AddSixteenByNineToVideos < ActiveRecord::Migration
  def self.up
    add_column :content, :aspect_ratio, :string, :limit => 10
  end

  def self.down
    remove_column :content, :aspect_ratio
  end
end
