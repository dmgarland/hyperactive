# Include hook code here

self.override_views = true
#self.load_once = false

# Override the standard locale files by dropping your own translations into
# config/locales/xx.yml
#
Dir[File.join("#{File.dirname(__FILE__)}/config/locales/*.yml")].each do |locale|
  I18n.load_path << locale
end

