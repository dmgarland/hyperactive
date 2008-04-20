class RedoModerationStatusesForContent < ActiveRecord::Migration
  
  def self.up
    # add the moderation status column
    add_column :content, :moderation_status, :string
    
    # get all content and set the moderation status for each
    content = Content.find(:all)
    content.each do |c|
      if c.hidden
        c.moderation_status = "hidden"
        c.save!
      elsif c.promoted
        c.moderation_status = "promoted"
        c.save!
      else
        c.moderation_status = "published"
        c.save!
      end
    end
    
    # remove unnecessary columns
    remove_column :content, :hidden
    remove_column :content, :promoted
    remove_column :content, :published
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end