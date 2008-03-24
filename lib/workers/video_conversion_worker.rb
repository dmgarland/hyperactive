class VideoConversionWorker < BackgrounDRb::MetaWorker
  
  set_worker_name :video_conversion_worker
  
  # This method is called when worker is loaded for the first time
  def create(args = nil)
   
  end
    
  # Converts a video file into a .flv and .ogg file and makes a .torrent for it.  
  #
  def convert_video(args)
    video_file = args[:absolute_path]
    video_id = args[:video_id]
    torrent_tracker = args[:torrent_tracker]
    unless RAILS_ENV == 'test'
      video_record = Video.find(video_id) 
      video_record.processing_status = 1 #the_video.PROCESSING #ProcessingStatuses[:processing]
      video_record.save
    end
    `nice -n +19 ffmpeg -i #{video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 180x136 #{video_file}.small.jpg`
    `nice -n +19 ffmpeg -i #{video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 320x240 #{video_file}.jpg`
    `nice -n +19 ffmpeg -i #{video_file} -ab 48 -ar 22050 -s 320x240 #{video_file}.flv`
    `nice -n +19 ffmpeg2theora #{video_file}`
    # note: the creation of torrent metafiles depends on the bittornado package, install it into your OS through your package manager
    `btmakemetafile.bittornado #{torrent_tracker}/announce #{video_file.chomp(File.extname(video_file)) + ".ogg"}`
    unless RAILS_ENV == 'test'
      video_record.processing_status = 2 #SUCCESS #ProcessingStatuses[:success]
      video_record.file_size = File.size?(video_file)
      video_record.save
    end
  end  
    
end

