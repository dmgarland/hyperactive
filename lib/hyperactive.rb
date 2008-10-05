# Hyperactive configuration options
#
# Allows site admins to set configuration values for Hyperactive in their 
# environment.rb files.  If we wanted for example to configure the  
# site name, we could set Hyperactive.site_name = "foo" 
#
#
# Configuration options attempt to provide a sane default which can be overridden in 
# environment.rb.
#
module Hyperactive

  # What torrent tracker should be used?
  #
  @@torrent_tracker = 'http://denis.stalker.h3q.com:6969/announce'
  mattr_accessor :torrent_tracker

  # What should the site be called?
  #
  @@site_name = 'Indymedia London'
  mattr_accessor :site_name # SITE_NAME

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
  
  # What elements should be allowed when pasting into a TinyMCE editor box in the site?
  #
  @@valid_elements_for_tiny_mce = "a[href|alt|title],strong/b,em,i,p,code,tt,br,ul,ol,li,blockquote,strike"
  mattr_accessor :valid_elements_for_tiny_mce
  
end

