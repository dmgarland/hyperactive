class Content < ActiveRecord::Base
    set_table_name "content"
    
    acts_as_ferret({:fields => [:title, :body, :summary, :place, :published_by, :hidden, :published, :date], :remote => true } )      
    
    has_many :videos
    has_many :photos
    has_many :file_uploads 
    
end