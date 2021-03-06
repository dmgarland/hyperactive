# Serves torrents using the functionality of the transmission gem found in /lib.
#
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
    @transmission = Transmission.new
    find_and_add_all_torrent_files
  end

  # Add a torrent download to the Transmission session
  #
  def add_torrent(file)
    begin
      torrent_download = @transmission.open(file)
      torrent_download.folder = File.dirname(file) +"/"
      torrent_download.start
    rescue Exception => e
      puts e
    end
  end

  # Stop a torrent
  #
  def stop_torrent(hash_string)
    torrent = get_torrent(hash_string)
    torrent.stop
  end
  
  # Start a torrent
  #
  def start_torrent(hash_string)
    torrent = get_torrent(hash_string)
    torrent.start
  end
  
  # Return an array of all torrents which transmission currently 
  # knows about
  #
  def list_all_torrents
    torrents = []
    @transmission.each do |torrent|
      torrents << torrent
    end
    return torrents
  end
  
  # Return an array of all torrents which are currently active
  #
  def list_active_torrents
    torrents = []
    @transmission.each do |torrent|
      torrents << torrent if torrent.active?
    end
    return torrents    
  end
  
  # Return a reference to a torrent object so we can play with it.
  # 
  def get_torrent(hash_string)
    @transmission.each do |torrent|
      return torrent if torrent.hash_string == hash_string
    end
  end

  private
  
  def find_and_add_all_torrent_files
    Dir['**/*.torrent'].each do |path|
      add_torrent(path)
    end
  end
  
end
