# Put your code that runs your task inside the do_work method it will be
# run automatically in a thread. You have access to all of your rails
# models.  You also get logger and results method inside of this class
# by default.
class TorrentWorker < BackgrounDRb::Rails

  require "rubygems"
  require "transmission"

  def initialize(key, args={})
    super(key, args={})
    do_work
  end

 # Create a new Transmission session
 #
  def do_work
    puts "@transmission object initialized"
    @transmission = Transmission.new      
  end

  # Add a torrent download to the Transmission session
  #
  def add_torrent(file)
    begin
      torrent_download = @transmission.open(file)
      puts "Torrent theoretically added."
      torrent_download.start
      puts "Torrent: #{torrent_download.name} started."
    rescue Exception => e
      puts e
    end
  end

  # Stop a torrent
  #
  def stop_torrent(hash_string)
    torrent = get_torrent(hash_string)
    torrent.stop
    puts "Torrent stopped.\n:#{torrent} "
  end
  
  def start_torrent(hash_string)
    torrent = get_torrent(hash_string)
    torrent.start
    puts "Torrent started. \n #{torrent}"
  end
  
  def list_all_torrents
    torrents = []
    @transmission.each do |torrent|
      puts "Torrent found: #{torrent}"
      torrents << torrent
    end
    return torrents
  end
  
  def list_active_torrents
    torrents = []
    @transmission.each do |torrent|
      torrents << torrent if torrent.active?
    end
    return torrents    
  end
  
  def get_torrent(hash_string)
    @transmission.each do |torrent|
      return torrent if torrent.hash_string == hash_string
    end
  end
  
end
