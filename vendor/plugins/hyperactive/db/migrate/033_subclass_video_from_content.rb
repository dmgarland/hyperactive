class SubclassVideoFromContent < ActiveRecord::Migration
  def self.up
    add_column :content, :file, :string
    add_column :content, :content_id, :integer
    add_column :content, :processing_status, :integer
    videos = Video.find(:all)
    videos.each do |video|
      video.destroy
    end
  end

  def self.down
    remove_column :content, :file
    remove_column :content, :content_id
    remove_column :content, :processing_status
  end
end
