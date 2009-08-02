class TruncateSourceFieldInContent < ActiveRecord::Migration
  def self.up
    change_column :content, :source, :string
  end

  def self.down
    change_column :content, :source, :text
  end
end

