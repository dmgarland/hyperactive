class CreateActionAlerts < ActiveRecord::Migration
  def self.up
    create_table :action_alerts do |t|
      t.column :summary, :string, :null => false
      t.column :on_front_page, :boolean, :null => false, :default => false
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
    end
  end

  def self.down
    drop_table :action_alerts
  end
end
