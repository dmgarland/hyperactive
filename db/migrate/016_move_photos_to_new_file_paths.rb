class MovePhotosToNewFilePaths < ActiveRecord::Migration
  def self.up
    photos = Photo.find(:all)
    photos.each do |photo|
      from_dir = "#{File.expand_path(RAILS_ROOT)}/public/system/photo/file/#{photo.id.to_s}"
      from = "#{File.expand_path(RAILS_ROOT)}/public/system/photo/file/#{photo.id.to_s}/#{photo.file.filename}"
      if File.exists?(from)
        to_dir = Date.today.strftime("#{File.expand_path(RAILS_ROOT)}/public/system/photo/%Y/%m/%d/#{photo.id.to_s}")
        to = Date.today.strftime("#{File.expand_path(RAILS_ROOT)}/public/system/photo/%Y/%m/%d/#{photo.id.to_s}/#{photo.file.filename}")
        FileUtils.mkdir_p(to_dir)
        FileUtils.cp(from, to)
        if File.exists?("#{from_dir}/medium/#{photo.file.filename}")
          FileUtils.cp("#{from_dir}/medium/#{photo.file.filename}", "#{to_dir}/#{photo.file.filename_base}-medium.#{photo.file.filename_extension}")
        end
        if File.exists?("#{from_dir}/thumb/#{photo.file.filename}")
          FileUtils.cp("#{from_dir}/thumb/#{photo.file.filename}", "#{to_dir}/#{photo.file.filename_base}-thumb.#{photo.file.filename_extension}")
        end
        if File.exists?("#{from_dir}/big_thumb/#{photo.file.filename}")
          FileUtils.cp("#{from_dir}/big_thumb/#{photo.file.filename}", "#{to_dir}/#{photo.file.filename_base}-big_thumb.#{photo.file.filename_extension}")
        end
        photo.created_on = Date.today
        photo.save
      end
    end
  end

  def self.down
  end
end
