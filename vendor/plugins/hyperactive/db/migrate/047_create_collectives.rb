class CreateCollectives < ActiveRecord::Migration
  def self.up
    create_table :collectives do |t|
      t.column :name, :string
      t.column :summary, :text
    end
  end

  def self.down
    drop_table :collectives
  end
end
