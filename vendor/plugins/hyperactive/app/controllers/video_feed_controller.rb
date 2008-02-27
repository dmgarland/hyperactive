class VideoFeedController < ApplicationController
  
  def latest
    videos = Video.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_feed(videos, "Latest videos")
  end
  
  def construct_feed(videos,feedtitle)
    options = {:feed => {:title => feedtitle,
               :id => "FOO",
              :item => {
                :pub_date => :date,
                :video_type => :video_type,
                :length => :file_size,
                :thumbnail => :thumbnail,
                :http_link => :relative_ogg_file,
                :torrent_link => :relative_torrent_file}
              }}
    respond_to do |wants|
      wants.atom { render_transmission_feed_for videos, options}
    end
  end           
  
end
