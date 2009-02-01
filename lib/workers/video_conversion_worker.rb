# A worker class to convert uploaded videos.  Currently it converts any uploaded video into
# an FLV, an OGG, and leaves the original in place.  It also generates a .torrent file 
# which points to the OGG, and adds the torrent to the list of active torrents held by the 
# TorrentWorker.
#
# It is necessary to have ffmpeg and ffmpeg2theora installed to get conversion to work.  
# Torrent creation requires that the bittornado package is installed.
#
class VideoConversionWorker < BackgrounDRb::Rails
  
  require 'digest/sha1'
  
  attr_accessor :video_file, :video_id
  
  # This method is called in it's own new thread when you
  # call new worker. args is set to :args
  #
  def do_work(args)
    @video_file = args[:absolute_path]
    @video_id = args[:video_id].to_i
    @torrent_tracker = args[:torrent_tracker]
    unless RAILS_ENV == 'test'
      video_record = Video.find(@video_id) 
      video_record.processing_status = 1 #the_video.PROCESSING #ProcessingStatuses[:processing]
      video_record.save
    end  
    video_information = MiniExiftool.new(@video_file)
    width = video_information["imagewidth"].to_f
    height = video_information["imageheight"].to_f
    if width/height == 16/9
      encode_width = 640
      encode_height = 360
    else
      encode_width = 320
      encode_height = 240
    end
    `nice -n +19 ffmpeg -i #{@video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 180x136 #{@video_file}.small.jpg`
    `nice -n +19 ffmpeg -i #{@video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 320x240 #{@video_file}.jpg`
    `nice -n +19 ffmpeg -i #{@video_file} -ab 64 -ar 22050 -b 500000 -r 25 -s #{encode_width}x#{encode_height} #{@video_file}.flv`
    `nice -n +19 ffmpeg2theora #{@video_file} -o #{@video_file}.ogg`
    ogg_file = @video_file + ".ogg"
    `btmakemetafile.bittornado #{@torrent_tracker} #{ogg_file}`
    torrent = ogg_file + ".torrent"
    torrent_worker = MiddleMan[:torrents]
    torrent_worker.add_torrent(torrent)
    unless RAILS_ENV == 'test'
      video_record.processing_status = 2 #SUCCESS #ProcessingStatuses[:success]
      video_record.media_size = File.size?(@video_file)
      video_record.save
      # blow out any cached versions of the video-related pages.
      FileUtils.rm "#{RAILS_ROOT}/public/system/cache/videos/#{@video_id}.html", :force => true   # never raises exception
      FileUtils.rm "#{RAILS_ROOT}/public/system/cache/featured_videos_json.html", :force => true   # never raises exception
    end
  end

end

