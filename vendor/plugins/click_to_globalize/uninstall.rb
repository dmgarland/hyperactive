require 'ftools'
rails_root         = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..'))
plugin_root        = File.join(rails_root, 'vendor', 'plugins', 'click_to_globalize')
templates_root     = File.join(plugin_root, 'templates')
prototype_version  = '1.5.1.1'

files = { :click_to_globalize_js     => File.join(rails_root, 'public', 'javascripts',  'click_to_globalize.js'),
          :click_to_globalize_css    => File.join(rails_root, 'public', 'stylesheets',  'click_to_globalize.css'),
          :locale_controller_rb      => File.join(rails_root, 'app',		 'controllers', 'locale_controller.rb'),
          :locale_helper_rb  		     => File.join(rails_root, 'app',		 'helpers',			'locale_helper.rb'),
          :_click_to_globalize_rhtml => File.join(rails_root, 'app',		 'views',			  'shared', '_click_to_globalize.rhtml') }

printf 'Downgrading prototype ... '
version = nil
File.open(File.join(rails_root, 'public', 'javascripts', 'prototype.js'), File::RDONLY) do |inline|
  while line = inline.gets
    version = line[/[\d\.]+/] if line.include?('Version:')
  end
end
updated = version > prototype_version
`rake rails:update:javascripts` unless updated
puts   updated ? 'SKIPPED' : 'DONE'

# Delete Click To Globalize files.
files.each do |file, path|
  file = path.split(File::SEPARATOR).last
  exists = File.exists?(path)
  printf "Deleting #{file} ... "
  File.delete path if exists
  puts exists ? 'DONE' : 'SKIPPED'
end

# Remove app/views/shared, if empty.
printf 'Deleting app/views/shared ... '
templates_path = File.join(rails_root, 'app', 'views', 'shared')
empty = Dir[templates_path+'/*'].entries.empty?
Dir.rmdir(templates_path) if empty
puts   empty ? 'DONE' : 'SKIPPED'

puts "\nClick To Globalize was correctly uninstalled."