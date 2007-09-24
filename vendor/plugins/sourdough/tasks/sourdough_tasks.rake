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
