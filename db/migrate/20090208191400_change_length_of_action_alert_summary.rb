class ChangeLengthOfActionAlertSummary < ActiveRecord::Migration
  def self.up
    change_table :action_alerts do |t|
      t.change :summary, :text
    end
  end

  def self.down
    change_table :action_alerts do |t|
      t.change :summary, :string
    end    
  end
end
