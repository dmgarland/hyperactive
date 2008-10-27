class AddSlugToCollective < ActiveRecord::Migration
  def self.up
    add_column :collectives, :slug, :string
    collectives = Collective.find(:all)
    collectives.each do |c|
      c.slug = Slugger.escape(c.name)
      c.save!
    end        
  end

  def self.down
    remove_column :collectives, :slug
  end
end
