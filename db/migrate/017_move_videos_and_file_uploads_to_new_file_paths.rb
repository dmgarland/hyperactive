class MoveVideosAndFileUploadsToNewFilePaths < ActiveRecord::Migration
  def self.up
    videos = Video.find(:all)
    videos.each do |video|
      from_dir = "#{File.expand_path(RAILS_ROOT)}/public/system/video/file/#{video.id.to_s}"
      if File.exists?(from_dir)
        to_dir = video.created_on.strftime("#{File.expand_path(RAILS_ROOT)}/public/system/video/%Y/%m/%d")
        FileUtils.mkdir_p(to_dir)
        FileUtils.cp_r(from_dir, "#{to_dir}/#{video.id.to_s}")
      end
    end
    file_uploads = FileUpload.find(:all)
    file_uploads.each do |file_upload|
      from_dir = "#{File.expand_path(RAILS_ROOT)}/public/system/file_upload/file/#{file_upload.id.to_s}"
      from = "#{from_dir}/#{file_upload.file}"
      if File.exists?(from)
        to_dir = file_upload.created_on.strftime("#{File.expand_path(RAILS_ROOT)}/public/system/file_upload/%Y/%m/%d/#{file_upload.id.to_s}")
        to = file_upload.created_on.strftime("#{to_dir}/#{file_upload.file}")
      end
    end
  end

  def self.down
  end
end
