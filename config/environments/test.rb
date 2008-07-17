# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test


# The click_to_globalize plugin fries the test environment.
# I can't figure out how to exclude a single plugin, so I'll have to specify which plugins
# should be loaded in the test environment.  This can be commented out if we stop using
# click_to_globalize at some point.
config.plugins = ["tiny_mce", "ssl_requirement", "active_rbac",  "engines", "has_many_polymorphs", "acts_as_ferret", "backgroundrb", "ez-where", "file_column", "paginating_find", "resource_feeder", "simply_helpful", "sub_list", "globalize", "simple_captcha", "white_list", "sanitize_params", "upload_column", "hyperactive"]


