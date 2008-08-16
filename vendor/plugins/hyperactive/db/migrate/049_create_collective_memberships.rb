class CreateCollectiveMemberships < ActiveRecord::Migration
  def self.up
    create_table :collective_memberships do |t|
      t.column :collective_id, :integer
      t.column :user_id, :integer
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :collective_memberships
  end
end
