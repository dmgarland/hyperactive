class EngineModelGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => false

  attr_reader   :engine_name
  
  def initialize(runtime_args, runtime_options = {})
    @engine_name = runtime_args.slice!(0)
    super
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name, "#{class_name}Test"

      # Model, test, and fixture directories.
      m.directory File.join('vendor/plugins/', engine_name, 'app/models', class_path)
      m.directory File.join('vendor/plugins/', engine_name, 'test/unit', class_path)
      m.directory File.join('vendor/plugins/', engine_name, 'test/fixtures', class_path)

      # Model class, unit test, and fixtures.
      m.template 'model.rb',      File.join('vendor/plugins/', engine_name, 'app/models', class_path, "#{file_name}.rb")
      m.template 'unit_test.rb',  File.join('vendor/plugins/', engine_name, 'test/unit', class_path, "#{file_name}_test.rb")

      unless options[:skip_fixture] 
       	m.template 'fixtures.yml',  File.join('vendor/plugins/', engine_name, 'test/fixtures', "#{table_name}.yml")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', File.join('vendor/plugins/', engine_name, 'db/migrate'), :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--skip-fixture",
             "Don't generation a fixture file for this model") { |v| options[:skip_fixture] = v}
    end
end
