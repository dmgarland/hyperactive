module VideosHelper
  
  def oggify(file_name)
    file_name.chomp(File.extname(file_name)) + ".ogg"
  end
  
  def torrentify(file_name)
    file_name.chomp(File.extname(file_name)) + ".ogg.torrent"
  end
  
end
