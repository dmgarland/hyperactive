class AddSiteUrlSetting < ActiveRecord::Migration
  def self.up
    default_url = StringSetting.new
    default_url.key = "site_url"
    default_url.value = "http://foo.org"
    default_url.save
  end

  def self.down
  end
end
