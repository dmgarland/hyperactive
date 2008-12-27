class SetDefaultSettings < ActiveRecord::Migration
  def self.up
    torrent_tracker = StringSetting.new(:key => 'torrent_tracker', :string_value => 'http://denis.stalker.h3q.com:6969/announce')
    torrent_tracker.save!
    site_name = StringSetting.new(:key => 'site_name', :string_value => 'Indymedia X')
    site_name.save!
    show_site_name_in_banner = BooleanSetting.new(:key => 'show_site_name_in_banner', :boolean_value => true)
    show_site_name_in_banner.save!
    banner_image = StringSetting.new(:key => 'banner_image', :string_value => 'logo_greyscale.png')
    banner_image.save!
    use_ssl = BooleanSetting.new(:key => 'use_ssl', :boolean_value => false)
    use_ssl.save!
    moderation_email_recipients = StringSetting.new(:key => 'moderation_email_recipients', :string_value => 'yourlist@yoursite.org')
    moderation_email_recipients.save!
    moderation_email_from = StringSetting.new(:key => 'moderation_email_from', :string_value => 'site@yoursite.org')
    moderation_email_from.save!
    use_local_css = BooleanSetting.new(:key => 'use_local_css', :boolean_value => 'use_local_css')
    use_local_css.save!
    valid_elements_for_tiny_mce = StringSetting.new(:key => 'valid_elements_for_tiny_mce', :string_value => "a[href|alt|title],strong/b,em,i,p,code,tt,br,ul,ol,li,blockquote,strike")
    valid_elements_for_tiny_mce.save!
    home_page_feed = StringSetting.new(:key => 'home_page_feed', :string_value => '')
    home_page_feed.save!
    rake_path = StringSetting.new(:key => 'rake_path', :string_value => "/usr/bin/rake")
    rake_path.save!
  end

  def self.down
  end
end
