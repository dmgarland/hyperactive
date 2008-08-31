class EngineGenerator < Rails::Generator::NamedBase
  attr_reader :plugin_path

  def initialize(runtime_args, runtime_options = {})
    @with_generator = runtime_args.delete("--with-generator")
    super
    @plugin_path = "vendor/plugins/#{file_name}"
    
    route_engine
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name

      m.directory "#{plugin_path}/app"
      m.directory "#{plugin_path}/app/controllers"
      m.directory "#{plugin_path}/app/helpers"
      m.directory "#{plugin_path}/app/models" 
      m.directory "#{plugin_path}/app/views"
      m.directory "#{plugin_path}/assets" 
      m.directory "#{plugin_path}/assets/images"
      m.directory "#{plugin_path}/assets/stylesheets"
      m.directory "#{plugin_path}/assets/javascripts"
      m.directory "#{plugin_path}/db"
      m.directory "#{plugin_path}/db/migrate"      
      m.directory "#{plugin_path}/lib"
      m.directory "#{plugin_path}/tasks"
      m.directory "#{plugin_path}/test"

      m.template 'README',        "#{plugin_path}/README"
      m.template 'MIT-LICENSE',   "#{plugin_path}/MIT-LICENSE"
      m.template 'Rakefile',      "#{plugin_path}/Rakefile"
      m.template 'init.rb',       "#{plugin_path}/init.rb"
      m.template 'install.rb',    "#{plugin_path}/install.rb"
      m.template 'uninstall.rb',  "#{plugin_path}/uninstall.rb"
      m.template 'plugin.rb',     "#{plugin_path}/lib/#{file_name}.rb"
      m.template 'tasks.rake',    "#{plugin_path}/tasks/#{file_name}_tasks.rake"
      m.template 'unit_test.rb',  "#{plugin_path}/test/#{file_name}_test.rb"
      m.template 'routes.rb',  "#{plugin_path}/routes.rb"
      
      if @with_generator
        m.directory "#{plugin_path}/generators"
        m.directory "#{plugin_path}/generators/#{file_name}"
        m.directory "#{plugin_path}/generators/#{file_name}/templates"

        m.template 'generator.rb', "#{plugin_path}/generators/#{file_name}/#{file_name}_generator.rb"
        m.template 'USAGE',        "#{plugin_path}/generators/#{file_name}/USAGE"
      end
    end
  end
  
  # Add the map.from_plugin => (:whatever) macro into the main application's routes file 
  #  unless it's already there.
  #
  def route_engine
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    logger.route "inserting map.from_plugin"
    unless options[:pretend]
      gsub_file File.join('config/routes.rb'), /(#{Regexp.escape(sentinel)})/mi  do |match|
        "#{match}\n  map.from_plugin :#{file_name}"
      end
    end
  end
  
  # It's quite crude to copy and paste this in here, but it's working for the moment.  It actually comes
  # from Rails::Generator::Commands.  This should be fixed.
  #
  def gsub_file(relative_destination, regexp, *args, &block)
    path = destination_path(relative_destination)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, File::RDWR|File::CREAT) { |file| file.write(content) }
  end  
  
end
