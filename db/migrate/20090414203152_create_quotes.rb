class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
