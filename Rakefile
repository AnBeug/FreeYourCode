require 'sinatra/activerecord/rake'

task :environment do
  require './server'
end

def db_dump_schema
  unless ENV['RACK_ENV'] == 'production'
    old_level, ActiveRecord::Base.logger.level = ActiveRecord::Base.logger.level, Logger::WARN
    File.open(File.join(File.dirname(__FILE__), 'db','schema.rb'), 'w', :external_encoding => Encoding::default_external) do |schema_file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, schema_file)
    end
    ActiveRecord::Base.logger.level = old_level
  end
end

task 'db:migrate' => :environment do
  db_dump_schema
end

task 'db:rollback' => :environment do
  step = ENV['STEP'] ? ENV['STEP'].to_i : 1
  ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
  db_dump_schema
end
