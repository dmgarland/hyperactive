class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :key
      t.string :string_value
      t.integer :integer_value
      t.boolean :boolean_value
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
