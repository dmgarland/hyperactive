class EngineAdminScaffoldGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false

  attr_reader   :engine_name,
                :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    
    @engine_name = runtime_args.slice!(0)
    super
    
    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")
      
      # Controller, helper, views, test and stylesheets directories.
      #
      # Common directories:
      #
      m.directory(File.join('vendor/plugins/', engine_name, '/app/models', class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/test/unit', class_path))    
      #
      # Admin directories:
      #
      m.directory(File.join('vendor/plugins/', engine_name, '/app/controllers/admin', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/helpers/admin', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/views/admin', controller_class_path, controller_file_name))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/views/layouts/admin', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/test/functional/admin', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/assets/stylesheets/admin', class_path))
      #
      # Public directories:
      #
      m.directory(File.join('vendor/plugins/', engine_name, '/app/controllers', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/helpers', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/views', controller_class_path, controller_file_name))
      m.directory(File.join('vendor/plugins/', engine_name, '/app/views/layouts', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/test/functional', controller_class_path))
      m.directory(File.join('vendor/plugins/', engine_name, '/assets/stylesheets', class_path))
      
      
      for action in scaffold_views
        m.template(
          "../../common_templates/view_#{action}.html.erb",
          File.join('vendor/plugins/', engine_name, '/app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end
      
      for action in scaffold_admin_views
        m.template(
          "../../common_templates/admin/view_#{action}.html.erb",
          File.join('vendor/plugins/', engine_name, '/app/views/admin', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end      
      
      # Test helper
      m.template('../../common_templates/test_helper.rb', File.join('vendor/plugins/', engine_name, '/test/test_helper.rb'))      

      # Layout and stylesheet for public site.
      m.template('../../common_templates/layout.html.erb', File.join('vendor/plugins/', engine_name, '/app/views/layouts', controller_class_path, "#{controller_file_name}.html.erb"))
      m.template('../../common_templates/style.css', File.join('vendor/plugins/', engine_name, '/assets/stylesheets/layout.css'))

      # Layout and stylesheet for admin site.
      m.template('../../common_templates/admin/layout.html.erb', File.join('vendor/plugins/', engine_name, '/app/views/layouts/admin', controller_class_path, "#{controller_file_name}.html.erb"))
      m.template('../../common_templates/admin/style.css', File.join('vendor/plugins/', engine_name, '/assets/stylesheets/admin/layout.css'))


      # Controller for public site
      m.template(
        '../../common_templates/controller.rb', File.join('vendor/plugins/', engine_name, '/app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )
      
      # Controller for admin 
      m.template(
        '../../common_templates/admin/controller.rb', File.join('vendor/plugins/', engine_name, '/app/controllers/admin', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      # Tests and helpers for public site
      m.template('../../common_templates/functional_test.rb', File.join('vendor/plugins/', engine_name, '/test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('../../common_templates/helper.rb',          File.join('vendor/plugins/', engine_name, '/app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))

      # Tests and helpers for admin
      m.template('../../common_templates/admin/functional_test.rb', File.join('vendor/plugins/', engine_name, '/test/functional/admin', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('../../common_templates/admin/helper.rb',          File.join('vendor/plugins/', engine_name, '/app/helpers/admin',     controller_class_path, "#{controller_file_name}_helper.rb"))
      
      m.route_plugin_resources controller_file_name
            
      m.dependency 'engine_model', [engine_name, name] + @args, :collision => :skip

    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} engine_admin_scaffold engine_name ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end

    def scaffold_admin_views
      %w[ index show new edit _form ]
    end
    
    def scaffold_views
      %w[ index show ]
    end

    def model_name
      class_name.demodulize
    end
  
  
    #  This inserts the routing declarations into the engine's routes file. 
    #  Copied from Rails::Generator::Commands and modified to make it do what we want.
    #
    def route_plugin_resources(*resources)
      resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')

      # Add the map.namespace(:admin) macro into the routes file unless it's already there.
      #
      sentinel = '# engine routes go here'
      logger.route "map.namespace(:admin) do |admin|"
      unless options[:pretend]
        gsub_file File.join('vendor/plugins', engine_name, 'routes.rb'), /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}\nmap.namespace(:admin) do |admin|\nend"
        end
      end           
      
      # Add the map.namespace resources macro into the admin namespace
      # in the routes file.
      #
      sentinel = 'map.namespace(:admin) do |admin|'
      logger.route "map.namespace resources #{resource_list}"
      unless options[:pretend]
        gsub_file File.join('vendor/plugins', engine_name, 'routes.rb'), /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}\n  admin.resources #{resource_list}"
        end
      end      

      # Add the map.resources macro into the routes file.
      #
      sentinel = 'end'
      logger.route "map.resources #{resource_list}"
      unless options[:pretend]
        gsub_file File.join('vendor/plugins', engine_name, 'routes.rb'), /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}\nmap.resources #{resource_list}"
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
