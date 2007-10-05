namespace :db do
  namespace :fixtures do
    desc "Deletes all fixture tables mentioned in FIXTURES environment in reverse order to avoid constraint problems"
    task :delete => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      ENV['FIXTURES'].split(',').reverse.each do |fixture_name|
        ActiveRecord::Base.connection.update "DELETE FROM #{fixture_name}"
      end
    end
  end
end

namespace :sourdough do
  namespace :fixtures do
    desc "Load plugin fixtures into the current environment's database."
    task :load => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['SOURDOUGH_FIXTURES'].split(/,/)).each do |fixture_file|
          file = File.join(RAILS_ROOT, 'vendor', 'plugins', 'sourdough', 'test', 'fixtures', fixture_file)
          Fixtures.create_fixtures(File.dirname(file), File.basename(file, '.*'))
      end
    end
  end
end

namespace :sourdough do
  namespace :fixtures do
    desc "Deletes all fixture tables mentioned in FIXTURES environment in reverse order to avoid constraint problems"
    task :delete => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      ENV['SOURDOUGH_FIXTURES'].split(',').reverse.each do |fixture_name|
        ActiveRecord::Base.connection.update "DELETE FROM #{fixture_name}"
      end
    end
  end
end
