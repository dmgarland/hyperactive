# Put your code that runs your task inside the do_work method it will be
# run automatically in a thread. You have access to all of your rails
# models.  You also get logger and results method inside of this class
# by default.
class VideoConversionWorker < BackgrounDRb::Rails
  
  require 'digest/sha1'
  require "#{RAILS_ROOT}/vendor/plugins/hyperactive/lib/rubytorrent/rubytorrent.rb"
  
  attr_accessor :video_file, :video_id
  
  # This method is called in it's own new thread when you
  # call new worker. args is set to :args  
  def do_work(args)
    @video_file = args[:absolute_path]
    @video_id = args[:video_id].to_i
    @torrent_tracker = args[:torrent_tracker]
    unless RAILS_ENV == 'test'
      video_record = Video.find(@video_id) 
      video_record.processing_status = 1 #the_video.PROCESSING #ProcessingStatuses[:processing]
      video_record.save
    end  
    `nice -n +19 ffmpeg -i #{@video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 180x136 #{@video_file}.small.jpg`
    `nice -n +19 ffmpeg -i #{@video_file} -ss 00:00:05 -t 00:00:01 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 320x240 #{@video_file}.jpg`
    `nice -n +19 ffmpeg -i #{@video_file} -acodec mp3 -ab 64 -ar 22050 -b 350000 -r 4 -deinterlace -s 320x240 #{@video_file}.flv`
    `nice -n +19 ffmpeg2theora #{@video_file}`
    puts "files created"
    # note: the creation of torrent metafiles depends on the transmissioncli package, install it into your OS through your package manager
    ogg_file = @video_file.chomp(File.extname(@video_file)) + ".ogg"
    #`transmissioncli -c #{ogg_file} -a  #{@torrent_tracker}/announce --port 51414 #{ogg_file + ".torrent"}`
    `btmakemetafile.bittornado #{@torrent_tracker}/announce #{ogg_file}`
    
    torrent = @video_file.chomp(File.extname(@video_file)) + ".ogg.torrent"
    torrent_worker = MiddleMan.get_worker(1)
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
  
  
  # Constructs a torrent file.  For whatever reason, the generated files aren't usable
  # by libtransmission, so this was all a big waste of time. I'll leave it in for
  # the moment in case I can get it to work with further hacking.  The other option 
  # would be to figure out how to extend the libtransmission gem wrapper to take
  # advantage of libtransmission's ability to make metainfo files.
  #
  # To invoke it instead of the btmakemetafile line above, we'd use:
  # torrent = construct_torrent("#{@video_file.chomp(File.extname(@video_file))}.ogg")
  #
  def construct_torrent(file, comment="")
    files = file
    mi = RubyTorrent::MetaInfo.new
    mii = RubyTorrent::MetaInfoInfo.new
    mii.name = file
    mii.length = files.inject(0) { |s, f| s + File.size(f) }   
    mii.piece_length = 32 * 1024
    mii.pieces = ""
    i = 0
    read_pieces(files, mii.piece_length) do |piece|
      mii.pieces += Digest::SHA1.digest(piece)
      i += 1
    end
    mi.info = mii
    tier = 1
    trackers = [@torrent_tracker]
    mi.announce = URI.parse(@torrent_tracker)
    mi.announce_list = trackers.map do |tier|
      tier.map { |x| URI.parse(x) }
    end 
    mi.comment = comment
    mi.created_by = "RubyTorrent make-metainfo (http://rubytorrent.rubyforge.org)"
    mi.creation_date = Time.now  
    name = "#{mii.name}.torrent" 
    File.open(name, "w") do |f|
      f.write mi.to_bencoding
    end
    return name    
  end
  
  
  private
  
  # Reads the pieces of the file into a buffer
  #
  def read_pieces(files, length)
    buf = ""
    files.each do |f|
      File.open(f) do |fh|
        begin
          read = fh.read(length - buf.length)
          if (buf.length + read.length) == length
            yield(buf + read)
            buf = ""
          else
            buf += read
          end
        end until fh.eof?
      end
    end
    yield buf
  end   

end

