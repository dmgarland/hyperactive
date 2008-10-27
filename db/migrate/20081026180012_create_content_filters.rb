class CreateContentFilters < ActiveRecord::Migration
  def self.up
    create_table :content_filters do |t|
      t.string :title
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :content_filters
  end
end
