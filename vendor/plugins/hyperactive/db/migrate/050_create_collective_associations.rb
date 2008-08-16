class CreateCollectiveAssociations < ActiveRecord::Migration
  def self.up
    create_table :collective_associations do |t|
      t.column :collective_associatable_id, :integer
      t.column :collective_associatable_type, :string
      t.column :collective_id, :integer
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
    end
  end

  def self.down
    drop_table :collective_associations
  end
end
