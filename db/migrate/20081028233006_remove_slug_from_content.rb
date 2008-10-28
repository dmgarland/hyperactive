class RemoveSlugFromContent < ActiveRecord::Migration
  def self.up
    remove_column :collectives, :slug
  end

  def self.down
    add_column :collectives, :slug, :string
  end
end
