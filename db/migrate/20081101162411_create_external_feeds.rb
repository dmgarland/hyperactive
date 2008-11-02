class CreateExternalFeeds < ActiveRecord::Migration
  def self.up
    create_table :external_feeds do |t|
      t.string :url
      t.string :title
      t.string :summary
      t.integer :collective_id

      t.timestamps
    end
  end

  def self.down
    drop_table :external_feeds
  end
end
