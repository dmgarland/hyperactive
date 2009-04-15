class AddDefaultIrcBotSettings < ActiveRecord::Migration
  def self.up
    default_server = StringSetting.new
    default_server.key = "irc_server"
    default_server.value = "irc.indymedia.org"
    default_server.save!    

    default_channel = StringSetting.new
    default_channel.key = "irc_channel"
    default_channel.value = "#hyperactive"
    default_channel.save!

    bot_name = StringSetting.new
    bot_name.key = "bot_name"
    bot_name.value = "hyperactive_bot"
    bot_name.save!

    activate_bot = BooleanSetting.new
    activate_bot.key = "activate_bot"
    activate_bot.value = false
    activate_bot.save!
  end

  def self.down
    StringSetting.find_by_key("irc_server").destroy
    StringSetting.find_by_key("irc_channel").destroy
    StringSetting.find_by_key("bot_name").destroy
    BooleanSetting.find_by_key("activate_bot").destroy
  end

end
