class JackAroundWithOtherMediaSoItDoesntExplodeTheSite < ActiveRecord::Migration
  def self.up
    other_medias = OtherMedia.all
    other_medias.each do |om|
      om.source = URI.extract(om.summary).first
      om.save!
    end
  end

  def self.down
  end
end
