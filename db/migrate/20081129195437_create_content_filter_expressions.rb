class CreateContentFilterExpressions < ActiveRecord::Migration
  def self.up
    create_table :content_filter_expressions do |t|
      t.string :regexp
      t.string :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :content_filter_expressions
  end
end
