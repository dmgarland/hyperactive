class CreateActionAlerts < ActiveRecord::Migration
  def self.up
    create_table :action_alerts do |t|
      t.column :title, :string, :null => false
      t.column :body, :text, :null => false
    end
  end

  def self.down
    drop_table :action_alerts
  end
end
