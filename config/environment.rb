# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')
require "#{RAILS_ROOT}/lib/extends_to_engines.rb"

if File.exist?("#{RAILS_ROOT}/config/mods_enabled.list")
  MODS_ENABLED = File.read("#{RAILS_ROOT}/config/mods_enabled.list").split("\n").freeze
else
  MODS_ENABLED = []
end

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

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = 'pt-BR'


  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # allow plugins in mods/
  config.plugin_paths << "#{RAILS_ROOT}/mods"

  # See Rails::Configuration for more options
  config.action_mailer.delivery_method = :sendmail

  # Let's put cached pages in a more convenient place than the root of the
  # public directory.  Note that this requires that the Apache setup points at
  # public/cache so that Apache serves cached pages properly.
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/system/cache"

  # Load any gems found in vendor/gems.  See http://errtheblog.com/posts/50-vendor-everything
  # for more on this.
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

  # Reload plugin code between requests so that we don't go insane when working on the
  # Hyperactive plugin.
  #config.reload_plugins = true

  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'daemons'
  config.gem 'slave'
  config.gem 'vpim'
  config.gem 'json'
  config.gem 'rio'
  config.gem 'ruby-debug'
  config.gem 'simple-rss'
  config.gem 'mini_exiftool'
  config.gem 'Ruby-IRC', :lib => 'IRC'
end

require 'validates_uri_existence_of'
gem 'rmagick'
require 'RMagick'

begin
  if Setting.table_exists?
    settings = Setting.all
    settings.each do |setting|
      Hyperactive.send("#{setting.key}=", setting.value)
    end
  end
rescue Mysql::Error
  # Ignore MySQL errors in order to allow "rake db:create:all" to run
end

