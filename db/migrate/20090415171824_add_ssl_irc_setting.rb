class AddSslIrcSetting < ActiveRecord::Migration
  def self.up
  	irc_over_ssl = BooleanSetting.new
  	irc_over_ssl.key = "irc_over_ssl"
  	irc_over_ssl.value = true
  	irc_over_ssl.save!  
  end

  def self.down
  end
end
