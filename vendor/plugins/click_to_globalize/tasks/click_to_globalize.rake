require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'erb'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'fileutils'

rails_root		     = File.expand_path(RAILS_ROOT)
plugin_root		     = File.join(rails_root, 'vendor', 'plugins', 'click_to_globalize')
plugin_root        = File.join(rails_root, 'vendor', 'plugins', 'for-1.2.x') unless File.exist?(plugin_root)
templates_root     = File.join(plugin_root, 'templates')
jstest             = File.join(plugin_root, 'test', 'lib', 'jstest')
prototype_version  = '1.5.1.1'

require jstest

files = { :click_to_globalize_js     => File.join(rails_root, 'public', 'javascripts',  'click_to_globalize.js'),
          :click_to_globalize_css    => File.join(rails_root, 'public', 'stylesheets',  'click_to_globalize.css'),
          :locale_controller_rb      => File.join(rails_root, 'app',		 'controllers', 'locale_controller.rb'),
          :locale_helper_rb  		     => File.join(rails_root, 'app',		 'helpers',			'locale_helper.rb'),
          :_click_to_globalize_rhtml => File.join(rails_root, 'app',		 'views',			  'shared', '_click_to_globalize.rhtml') }

desc 'Default: run click task.'
task :default => :click

desc 'Run tests.'
task :click => ['click:test']

namespace :click do
  desc 'Test the click_to_globalize plugin.'
  task :test => ['click:test:all']
  
  namespace :test do
	  desc 'Test both ruby and javascript code.'
	  task :all => [:ruby, :js]

	  desc 'Test ruby code.'
	  Rake::TestTask.new(:ruby) do |t|
		  t.libs << "#{plugin_root}/lib"
		  t.libs << "#{plugin_root}/test/test_helper"
		  t.pattern = "#{plugin_root}/test/**/*_test.rb"
		  t.verbose = true
	  end

    # Taken from Prototype rake tasks.
	  desc "Runs all the JavaScript unit tests and collects the results"
	  JavaScriptTestTask.new(:js) do |t|
		  tests_to_run		 = ENV['TESTS']		 && ENV['TESTS'].split(',')
		  browsers_to_test = ENV['BROWSERS'] && ENV['BROWSERS'].split(',')

		  t.mount("/public", "#{rails_root}/public")
		  t.mount("/test", "#{plugin_root}/test")

      test_files = (Dir["#{plugin_root}/test/unit/*.html"] + Dir["#{plugin_root}/test/functional/*.html"])
  		test_files.sort.reverse.each do |test_file|
  		  test_file = test_file.gsub(plugin_root, '')
		  	test_name = test_file[/.*\/(.+?)\.html/, 1]
		  	t.run(test_file) unless tests_to_run && !tests_to_run.include?(test_name)
		  end

		  %w( safari firefox ie konqueror opera ).each do |browser|
			  t.browser(browser.to_sym) unless browsers_to_test && !browsers_to_test.include?(browser)
		  end
	  end
	  
	  desc 'Generate documentation for the click_to_globalize plugin.'
    Rake::RDocTask.new(:rdoc) do |rdoc|
    	rdoc.rdoc_dir = "#{plugin_root}/rdoc"
    	rdoc.title		= 'ClickToGlobalize'
    	rdoc.options << '--line-numbers' << '--inline-source'
    	rdoc.rdoc_files.include("#{plugin_root}/README")
    	rdoc.rdoc_files.include("#{plugin_root}/lib/**/*.rb")
    end
  end

  desc 'Setup the click_to_globalize plugin (alias for click:install).'
  task :setup => :install
  
  desc 'Install the click_to_globalize plugin.'
  task :install do
    # Upgrade Prototype version, if needed.
    printf "Upgrading prototype to version #{prototype_version} ... "
    version = nil
    File.open(File.join(rails_root, 'public', 'javascripts', 'prototype.js'), File::RDONLY) do |inline|
      while line = inline.gets
        version = line[/[\d\.]+/] if line.include?('Version:')
      end
    end
    outdated = version < prototype_version
    File.cp File.join(templates_root, 'prototype.js'), File.join(rails_root, 'public', 'javascripts') if outdated
    puts   outdated ? 'DONE' : 'SKIPPED'

    # Create the app/views/shared, if needed.
    shared_folder = File.join(rails_root, 'app', 'views', 'shared')
    FileUtils.mkdir(shared_folder) unless File.directory?(shared_folder)

    # Copy Click To Globalize files.
    files.each do |file, path|
      file = path.split(File::SEPARATOR).last
      printf "Copying #{file} ... "
      File.cp File.join(templates_root, file), path
      puts 'DONE'
    end
    
    # for-1.2.x -> click_to_globalize
    File.mv(plugin_root, File.join(rails_root, 'vendor', 'plugins', 'click_to_globalize'))
    
    puts "\nClick To Globalize was correctly installed."
  end
    
  desc 'Show the diffs for each file, camparing the app files with the plugin ones.'
  task :diff do
    files.each do |file, path|
      file = path.split(File::SEPARATOR).last
      res  = `diff #{path} #{templates_root}/#{file}`
    	puts "#{file.upcase}\n#{res}" unless res.empty?
    end
  end

  desc 'Prepare the folder plugin, copying files from the app, here.'
  task :prepare do
    files.each { |file, path| File.cp path, templates_root }
  end
end