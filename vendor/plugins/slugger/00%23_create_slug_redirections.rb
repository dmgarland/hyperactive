class CreateSlugRedirections < ActiveRecord::Migration
  def self.up
    create_table :slug_redirections do |t|
      t.string :model
      t.string :scope
      t.string :from
      t.string :to
    end
    add_index :slug_redirections, :from
  end

  def self.down
    drop_table :slug_redirections
  end
end