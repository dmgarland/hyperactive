class AddPhoneContactToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :contact_phone, :string
  end

  def self.down
    remove_column :videos, :contact_phone
  end
end
