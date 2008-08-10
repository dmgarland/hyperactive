require 'fileutils'
include FileUtils

dir = "#{File.dirname(__FILE__)}/javascripts"
rails_javascripts_dir = "#{RAILS_ROOT}/public/javascripts"

puts "copying user-info.js to #{rails_javascripts_dir}"
cp "#{dir}/user-info.js", rails_javascripts_dir
if File.exists?("#{rails_javascripts_dir}/json.js")
  puts "#{rails_javascripts_dir}/json.js already exists"
else
  puts "copying json.js to #{rails_javascripts_dir}"
  cp "#{dir}/json.js", rails_javascripts_dir
end

if File.exists?("#{rails_javascripts_dir}/cookie.js")
  puts "#{rails_javascripts_dir}/cookie.js already exists"
else
  puts "copying cookie.js to #{rails_javascripts_dir}"
  cp "#{dir}/cookie.js", rails_javascripts_dir
end
