# Force Globalize loading.
if Rails::VERSION::STRING.match /^1\.2+/
  load_plugin(File.join(RAILS_ROOT, 'vendor', 'plugins', 'globalize'))
else
  Rails::Initializer.run { |config| config.plugins = [ :globalize ] }
end

require 'click_to_globalize'