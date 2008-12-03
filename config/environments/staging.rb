# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
# config.action_mailer.delivery_method = :sendmail

config.action_mailer.raise_delivery_errors = true

ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.sendmail_settings = {
  :location       => '/usr/sbin/sendmail',
  :arguments      => '-i -t -f site@london.escapegoat.org'
}

# Does a random test to see if the app should delete all expired sessions
# now.  The odds are 1 in whatever value is provided here.  0 will disable
# this option.  Default is 1000.  A busy site may want 10000 or higher.
#
#CGI::Session::ActiveRecordStore::Session.auto_clean_sessions = 500