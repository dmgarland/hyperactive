# Hangs out in your irc channel and tells you what's going on.
#
class IrcWorker < BackgrounDRb::Rails

  require 'rubygems'
  require 'IRC'

  def initialize(key, args={})
    super(key, args)
  end

  # Connect to the server if there is no bot.
  #
  def do_work(args)
    connect_to_irc if @bot.nil?
  end

  # Join the channel defined in the site's settings and start hanging out.
  #
  def connect_to_irc
    @channel = Setting.find_by_key("irc_channel").value
    @server = Setting.find_by_key("irc_server").value
    @port = Setting.find_by_key("irc_port").value
    @bot_name = Setting.find_by_key("bot_name").value
    @activate_bot = Setting.find_by_key("activate_bot").value
    @ssl = Setting.find_by_key("irc_over_ssl").value
    if @activate_bot
      @bot = IRC.new(@bot_name, @server, @port, "HyperactiveBot", :use_ssl => @ssl)
      IRCEvent.add_callback('endofmotd') { |event| @bot.add_channel(@channel) }
      IRCEvent.add_callback('join') { |event|
        @bot.send_message(@channel, say_random_quote) if event.from == @bot_name
      }
      IRCEvent.add_callback('disconnect') {|event|
        sleep(20)
        @bot.join(@channel)
      }
      IRCEvent.add_callback('privmsg') { |event| receive_message(event) }
      @bot.connect
    end
  end

  def notify_irc_channel(message)
    if @activate_bot
      begin
        @bot.send_message(@channel, message)
      rescue
        # don't do anything exciting, just catch the error
      end
    end
  end

  protected

  def receive_message(event)
    message = event.message if event.message.downcase =~ /#{@bot_name}:/
    if message =~ /profound/ || message =~ /dirtbag/ || message =~ /think/ || message =~ /what/ || message =~ /how/ || message =~ /why/
      @bot.send_message(event.channel, say_random_quote)
    end
    if message =~ /encode video \d+/
      id = message.scan(/\d+/).first.to_i
      begin
        video = Video.find(id)
        video.convert
      rescue
        notify_irc_channel("I can't find that video, are you sure it exists?")
      end
    end
    if message =~ /encoding/
      video_count = 0
      MiddleMan.jobs.each do |job|
        video_count = video_count + 1 if job[0] =~ /video/
      end
      notify_irc_channel("There are currently #{video_count} videos encoding.")
    end
    if message =~ /thanks/ || message =~ /thank you/
      notify_irc_channel("No problem, #{event.from}")
    end
  end

  def say_random_quote
    quotes = Quote.find(:all)
    quote = quotes[rand(quotes.length)]
    return quote.body
  end

end

