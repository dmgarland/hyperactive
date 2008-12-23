require 'ftools'

namespace :hyperactive do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database,
  then copy a video file into place, ensure that backgroundrb is running, and convert
  the video." 
  task :seed => :environment do
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
      Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
    Rake::Task["backgroundrb:start"].execute
    Rake::Task["hyperactive:copy_video_file_into_place"].execute
    Rake::Task["hyperactive:convert_video"].execute
  end
  
  desc 'Copy the video file from the fixtures into the proper directoy path 
  for the video object in the database.'
  task :copy_video_file_into_place => :environment do
    video_path = RAILS_ROOT + "/public/system/video/2008/12/23/6"
    File.makedirs(video_path)
    src = RAILS_ROOT + "/test/fixtures/fight_test.wmv"
    File.copy(src, video_path)
  end
  
  desc 'Convert the first video in the seed data'
  task :convert_video => :environment do
    v = Video.first
    v.convert
  end

  desc 'Destroys all databases, rebuilds them, runs migrations, inserts fixtures data,
  and converts the video to provide a more pleasant default site for development.'
  task :burn_it_down => :environment do
    Rake::Task["db:drop:all"].invoke
    Rake::Task["db:create:all"].invoke
    `rake db:migrate RAILS_ENV=development`
    `rake xapian:rebuild_index models='Content Collective' RAILS_ENV=development`
    `rake hyperactive:seed RAILS_ENV=development`
  end
  
  desc 'Dump a database to yaml fixtures.  Set environment variables DB
  and DEST to specify the target database and destination path for the
  fixtures.  DB defaults to development and DEST defaults to RAILS_ROOT/
  db/fixtures.'
  task :dump => :environment do
    path = ENV['DEST'] || "#{RAILS_ROOT}/db/fixtures"
    db   = ENV['DB']   || 'development'
    sql  = 'SELECT * FROM %s'

    ActiveRecord::Base.establish_connection(db)
    ActiveRecord::Base.connection.select_values('show tables').each do |table_name|
      i = '000'
      File.open("#{path}/#{table_name}.yml", 'wb') do |file|
        file.write ActiveRecord::Base.connection.select_all(sql %
  table_name).inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      end
    end
  end

  # ActiveRecord::Base.connection.select_values('show tables')
  # is mysql specific
  # SQLite:  ActiveRecord::Base.connection.select_values('.table')
  # Postgres
  # table_names = ActiveRecord::Base.connection.select_values(<<-end_sql)
  #    SELECT c.relname
  #    FROM pg_class c
  #      LEFT JOIN pg_roles r     ON r.oid = c.relowner
  #      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  #    WHERE c.relkind IN ('r','')
  #      AND n.nspname IN ('myappschema', 'public')
  #      AND pg_table_is_visible(c.oid)
  # end_sql
end

