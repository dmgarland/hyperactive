class AddDefaultSslPort < ActiveRecord::Migration
  def self.up
  	irc_port = StringSetting.new
  	irc_port.key = "irc_port"
  	irc_port.value = "6697"
  	irc_port.save!
  end

  def self.down
  end
end
