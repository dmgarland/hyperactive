# Hyperactive configuration options
#
# Allows site admins to set configuration values for Hyperactive.
# If we wanted for example to configure the site name, we could set
# Hyperactive.site_name = "foo"
#
#
# This configuration options attempt to provide a sane default which can be
# overridden in config/initializers/hyperactive.rb.
#
module Hyperactive

  # What torrent tracker should be used?
  #
  @@torrent_tracker = 'http://denis.stalker.h3q.com:6969/announce'
  mattr_accessor :torrent_tracker

  # What should the site be called?
  #
  @@site_name = 'Indymedia X'
  mattr_accessor :site_name

  # Should the site name be displayed in the banner?
  #
  @@show_site_name_in_banner = true
  mattr_accessor :show_site_name_in_banner

  # What banner image should be used?
  #
  @@banner_image = "logo_greyscale.png"
  mattr_accessor :banner_image


  # Should the site use SSL encryption for publishing, logins etc?
  #
  @@use_ssl = false
  mattr_accessor :use_ssl

  # Who should get emails if the site explodes?
  #
  @@moderation_email_recipients = 'you@yoursite.org'
  mattr_accessor :moderation_email_recipients

  # What address should moderation emails from the site come from?
  #
  @@moderation_email_from = "site <site@yoursite.org>"
  mattr_accessor :moderation_email_from

  # Should the site use ssl for publishing, logins, etc?
  #
  @@use_local_css = false
  mattr_accessor :use_local_css

  # What are the possible content moderation statuses?
  #
  @@content_moderation_statuses = %w(published promoted hidden featured)
  mattr_accessor :content_moderation_statuses

  # What elements should be allowed when pasting into a TinyMCE editor box in
  # the site?
  #
  @@valid_elements_for_tiny_mce = "a[href|alt|title],strong/b,em,i,p,code,tt,br,ul,ol,li,blockquote,strike"
  mattr_accessor :valid_elements_for_tiny_mce

  # If there's a feed that needs to be pulled onto the home page, what's
  # its location? Note: there's no default setting for this, if you want to
  # pull a feed onto the home page, you can set Hyperactive.home_page_feed
  # somewhere in an environment file or initializer.
  #
  mattr_accessor :home_page_feed

  # Where is rake on this system?  Usually it's at /usr/bin/rake, but on some
  # systems it may be at a different place.
  #
  @@rake_path = "/usr/bin/rake"
  mattr_accessor :rake_path

  # Should the irc bot for this site be activated when the job scheduler
  # starts?
  #
  @@activate_bot = false
  mattr_accessor :activate_bot

  # What server should the irc bot join?
  #
  @@irc_server = "irc.indymedia.org"
  mattr_accessor :irc_server

  # What channel should the irc bot join?
  #
  @@irc_channel = "#hyperactive"
  mattr_accessor :irc_channel

  # What name should the irc bot use?
  #
  @@bot_name = "hyperactive_bot"
  mattr_accessor :bot_name

  # What base url should be used by the irc bot for notifications?
  #
  @@site_url = "http://foo.org"
  mattr_accessor :site_url

	# What port should the irc bot connect to? Note: default irc port for most
	# servers is 6667, but Indymedia's SSL encrypted port is 6697 so that's
	# the default here.
	#
	@@irc_port = "6697"
	mattr_accessor :irc_port

	# Should the irc bot attempt to use SSL?
	#
	@@irc_over_ssl = true
	mattr_accessor :irc_over_ssl

	# What is the mobile subdomain?
	#
	@@mobile_subdomain = "mob"
	mattr_accessor :mobile_subdomain


  # Should the dispatch number show up on the mobile template?
  #
	@@show_dispatch_number_on_mobile_template = false
	mattr_accessor :show_dispatch_number_on_mobile_template

  # The dispatch number for the site
  #
  @@dispatch_number = "123456"
  mattr_accessor :dispatch_number

end

