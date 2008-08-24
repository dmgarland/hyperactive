class Collective < ActiveRecord::Base
  
  validates_length_of :name, :maximum=>255
  validates_presence_of :name, :summary

  has_many :collective_memberships
  has_many :users, :through => :collective_memberships

  has_many_polymorphs :collective_associatables, :from => [:videos, :events, :articles], :through => :collective_associations

  image_column  :image, 
                :versions => { :thumb => "c96x96", :small => "c32x32"},
                :extensions => ["gif", "png", "jpg"],
                :root_dir => File.join(RAILS_ROOT, "public", "system"),
                :web_root => "/system", 
                :store_dir => proc {|record, file| 
                                      if !record.created_on.nil?
                                        return record.created_on.strftime("group/image/%Y/%m/%d/") +  record.id.to_s
                                      else
                                        return Date.today.strftime("group/image/%Y/%m/%d/") +  record.id.to_s
                                      end
                                   }
                
  before_destroy :delete_image
  before_update :delete_image_if_new_uploaded
  
  # Recursively deletes the image and then the directory which the image
  # was stored in.
  #
  def delete_image
    if !self.image.nil? 
      FileUtils.remove_dir(image.store_dir) if File.exists?(image.store_dir)
    end
  end 
  
  
  # Recursively deletes the image and then the directory which the image
  # was stored in, if a new image was uploaded during this request.
  #
  def delete_image_if_new_uploaded
    if !self.image.nil? && self.image.new_file?
      FileUtils.remove_dir(image.store_dir) if File.exists?(image.store_dir)
    end
  end
  
  def has_articles?
    !articles.empty?
  end
  
  def has_events?
    !events.empty?
  end
  
  def has_videos?
    !videos.empty?
  end
  
  def includes_content?(content)
    self.collective_associatables.to_a.include?(content)
  end

end
