# Hangs out in your irc channel and tells you what's going on.
#
class IrcWorker < BackgrounDRb::Rails
  
  require 'rubygems'
  require 'IRC'

  def initialize(key, args={})
    super(key, args)
    #do_work(args)
  end  
   
  # Join the channel defined in the site's settings and start hanging out
  # 
  def do_work(args)
    @channel = Setting.find_by_key("irc_channel").value
    puts "channel: #{@channel}"
    @server = Setting.find_by_key("irc_server").value
    @bot_name = Setting.find_by_key("bot_name").value
    @activate_bot = Setting.find_by_key("activate_bot").value
    if @activate_bot
      @bot = IRC.new(@bot_name, @server, "6667", "HyperactiveBot")
      IRCEvent.add_callback('endofmotd') { |event| @bot.add_channel(@channel) }
      IRCEvent.add_callback('join') { |event|
        @bot.send_message(@channel, say_random_quote) if event.from == @bot_name
      }
      IRCEvent.add_callback('privmsg') { |event| receive_message(event) }
      @bot.connect
    end
  end

  def notify_irc_channel(message)
    if @activate_bot
      @bot.send_message(@channel, message)
    end
  end

  protected

  def receive_message(event)
    message = event.message if event.message.downcase =~ /marcos:/
    if message =~ /profound/
      @bot.send_message(event.channel, say_random_quote)
    end
  end
  
  def say_random_quote
    quotes = Quote.find(:all)
    quote = quotes[rand(quotes.length)]
    return quote.body
  end

end
