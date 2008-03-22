# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service ]#, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  #config.plugins = %W( engines active_rbac hyperactive click_to_globalize * )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  config.action_mailer.delivery_method = :sendmail
  
  # Let's put cached pages in a more convenient place than the root of the 
  # public directory.  Note that this requires that the Apache setup points at
  # public/cache so that Apache serves cached pages properly.
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/system/cache/"  
      
  # Load any gems found in vendor/gems.  See http://errtheblog.com/posts/50-vendor-everything
  # for more on this.
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

end

# Add new inflection rules using the following format 
# (all these examples are active by default):
Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
  inflect.uncountable %w( content)
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below



require 'acts_as_ferret'
require 'tag_extensions'
require 'ruby-debug'
require 'vpim/icalendar'

TORRENT_TRACKER = 'http://london.escapegoat.org:6969'
SITE_NAME = 'Indymedia London'
#require 'tag'
#require 'place_tag'
Debugger.start

ActiveRbac.controller_layout = "admin" 
#ActiveRbac.controller_registration_signup_fields << "login"
ActiveRecord::Base.verification_timeout = 14400

# This is necessary to ensure that keys in JSON strings get quoted:
ActiveSupport::JSON.unquote_hash_key_identifiers = false

# Globalize configuration for internationalization purposes
include Globalize
Locale.set_base_language('en-GB')
Locale.set('en-GB')

unless RAILS_ENV == 'test'
  # Who gets emails when the site explodes?
  ExceptionNotifier.exception_recipients = %w(yossarian@aktivix.org)
  ExceptionNotifier.sender_address = %("Application Error" <error@london.escapegoat.org>)
  ExceptionNotifier.email_prefix = "[Hyperactive] "
end

# In production mode, loads every view translation into memory once from the database
# when the application starts, avoiding database calls from globalize.
Dispatcher.to_prepare :globalize_view_translations do
  if RAILS_ENV == 'production' 
    translator = Globalize::DbViewTranslator.instance
      #Or whichever other means used to keep track of app specific supported languages 
      SupportedLanguage.find(:all).each do |lang|
        ViewTranslation.find(:all, :conditions => ['globalize_translations.language_id = ?', lang.language_id]).each do |tr|
          translator.send(:cache_add, tr.tr_key, tr.language, tr.pluralization_index, tr.text)
        end  
    end 
  end
end