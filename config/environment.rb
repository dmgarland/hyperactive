# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service ]#, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [:engines, :active_rbac, :white_list, :sanitize_params, :hyperactive, :all] 

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  
  # TODO 2.1 : this shouldn't be necessary, the code in vendor/plugins/hyperactive/init.rb should do this job.
  # But it doesn't.
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"


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
  
  # Reload plugin code between requests so that we don't go insane when working on the
  # Hyperactive plugin.
  #config.reload_plugins = true

  config.gem 'mislav-will_paginate', :version => '2.3.4', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'acts_as_ferret'

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

# Some general configuration stuff
#
Hyperactive.banner_image = "banner.png"
Hyperactive.show_site_name_in_banner = false
Hyperactive.use_ssl = true

# Email configuration
# 
# What address should hide/unhide/inappropriate content notifications be sent to?
#
Hyperactive.moderation_email_recipients = 'imc-london-moderation@lists.indymedia.org'

# Who should moderation emails originate from?
#
Hyperactive.moderation_email_from = "indy site <site@london.indymedia.org.uk>"

# Who gets emails when the site explodes?
#
unless RAILS_ENV == 'test'
  ExceptionNotifier.exception_recipients = %w(yossarian@aktivix.org)
  ExceptionNotifier.sender_address = %("Application Error" <error@london.indymedia.org.uk>)
  ExceptionNotifier.email_prefix = "[Hyperactive] "
end


###########################################################################
###########################################################################
#
# Most of the stuff below this point shouldn't need to be edited by
# most sites.
#
require 'tag_extensions'
require 'ruby-debug'
require 'vpim/icalendar'

Debugger.start

ActiveRbac.controller_layout = "admin" 
ActiveRecord::Base.verification_timeout = 14400

# This is necessary to ensure that keys in JSON strings get quoted:
#ActiveSupport::JSON.unquote_hash_key_identifiers = false

# Globalize configuration for internationalization purposes
include Globalize
Locale.set_base_language('en-GB')
Locale.set('en-GB')

# What HTML tags, attributes, and protocols are allowed in articles, events, and videos?
#
WhiteListHelper.tags = %w(strong em b i p code tt br ul ol li a blockquote strike)
WhiteListHelper.attributes = %w(href src alt title)
WhiteListHelper.protocols  = %w(ftp http https irc mailto feed)

TINY_MCE_VALID_ELEMENTS = "a[href|alt|title],strong/b,em,i,p,code,tt,br,ul,ol,li,blockquote,strike"

# There's a weird "not working the first time" class loading bug I'm getting with 
# has_many_polymorphs.  Requiring the parent model explicitly here fixes it.
require 'collective'
require 'collective_association'

ROUTES_PROTOCOL = (ENV["RAILS_ENV"] =~ /development/ ? "http://" : "https://")

# In production mode, loads every view translation into memory once from the database
# when the application starts, avoiding database calls from globalize.
#Dispatcher.to_prepare :globalize_view_translations do
#  if RAILS_ENV == 'production' 
#    translator = Globalize::DbViewTranslator.instance
#      #Or whichever other means used to keep track of app specific supported languages 
#      SupportedLanguage.find(:all).each do |lang|
#        ViewTranslation.find(:all, :conditions => ['globalize_translations.language_id = ?', lang.language_id]).each do |tr|
#          translator.send(:cache_add, tr.tr_key, tr.language, tr.pluralization_index, tr.text)
#        end  
#    end 
#  end
#end