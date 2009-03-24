#
# Sourdough app generator for Ruby on Rails 2.3.2.
#

app_name = File.split(root).last

plugin 'annotate_models',        :git => 'git://github.com/rotuka/annotate_models.git'
plugin 'assert_valid_markup',    :git => 'git://github.com/wireframe/assert_valid_markup.git'
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git'
plugin 'sourdough',              :git => 'git://github.com/zenhob/sourdough.git -r rails2.3'

plugin 'file_column', :git => 'git://github.com/kch/file_column.git' if yes? 'Attachment support?'

environment %{
  config.plugins = [ :sourdough, :all ]
}

# test setup: thoughbot and model factory # {{{
gem "thoughtbot-shoulda", :lib => false, :source => "http://gems.github.com"
gem "modelfactory",       :lib => false

Dir.rmdir 'test/fixtures'

file 'test/factory.rb', %{
require 'model_factory'
class Factory
  extend ModelFactory
end
}

gsub_file 'test/test_helper.rb', /(#{Regexp.escape("require 'test_help'")})/ do |match|
    %{#{match}
require 'shoulda'
require File.dirname(__FILE__) + '/factory.rb'
}
end
# }}}

# example database config {{{
File.unlink 'config/development.yml'
file 'config/database.yml.example', %{
login: &login
  adapter: postgresql
  encoding: unicode
  pool: 5
  username:
  password:
  #host: localhost
  #port: 5432
  #schema_search_path: myapp,sharedapp,public
  #min_messages: warning

development:
  database: #{app_name}_development
  <<: *login

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  database: #{app_name}_test
  <<: *login

production:
  database: #{app_name}_production
  <<: *login
}
# }}}

initializer "revision.rb", <<'' # {{{ http://gist.github.com/77193
# Attempt to extract the currently running revision number.
# In production mode, attempts to use the Capistrano REVISION file.
# If development mode, attempts to use the .svn/entries file, then git-svn, and finally git-describe.
# If a revision can't be determined, the value is 'x'.
REVISION = begin
  revision_path = File.dirname(__FILE__) + '/../REVISION'
  entries_path = '.svn/entries'
  if ENV['RAILS_ENV'] == 'production'
    if File.exists?(revision_path)
      File.open(revision_path, "r") do |rev|
        rev.readline.chomp
      end
    end
  elsif ENV['RAILS_ENV'] == 'development'
    if File.exists?(entries_path)
      File.open(entries_path, "r") do |entries|
        entries.to_a[3].chomp
      end
    elsif File.exists? '.git'
      rev = 'x'
      # using detect so that success will short circuit
      [ "git svn find-rev HEAD", "git describe" ].detect do |cmd|
        possible_rev = `#{cmd}`
        rev = possible_rev.chomp if $?.success?
        $?.success?
      end
      rev
    else
      'x'
    end
  else
    'x'
  end
end

# }}}

if yes? 'True unit and functional tests?' # {{{
  gem "unit_record",        :lib => false
  gem "unit_controller",    :lib => false

  file 'test/unit/unit_test_helper.rb', %{
require File.dirname(__FILE__) + '/../test_helper.rb'
require 'unit_record'
require 'unit_controller'

ActiveRecord::Base.disconnect!

module ControllerTestHelpers
  # Prepare a controller for unit testing.
  def unit_test(controller)
    controller.do_not_render_view
  end
end

# Automatically prepare the controller for unit testing.
class ActionController::TestCase
  include ControllerTestHelpers
  def setup
    super
    unit_test @controller
  end
end
}

  file 'test/functional/functional_test_helper.rb', %{
require File.dirname(__FILE__) + '/../test_helper.rb'
}
end
# }}}

if yes? 'Integration testing support?' # {{{
  plugin 'spider_test', :git => 'git://github.com/courtenay/spider_test.git'
  gem    'webrat',      :lib => false, :source => "http://gems.github.com"

  file 'test/integration/integration_test_helper.rb', %{
require File.dirname(__FILE__) + '/../test_helper.rb'
require 'webrat'
}
end # }}}

if yes? 'Enable Amazon S3?' # {{{
  file 'config/amazon_s3.yml.example', %{
access_key: &access_key
  access_key_id:
  secret_access_key:

development:
  bucket_name: #{app_name}_development
  <<: *access_key

test:
  bucket_name: #{app_name}_test
  <<: *access_key

production:
  bucket_name: #{app_name}
  <<: *access_key
}
end
# }}}

if yes? 'Use hanna RDoc template?' # {{{
  gem "mislav-hanna", :lib => false, :source => "http://gems.github.com"
  gsub_file "Rakefile", /(#{Regexp.escape("require 'rake/rdoctask'")})/ do |match|
    "require 'hanna/rdoctask'"
  end
  warn 'NOTE that rake will fail unless hanna is installed: sudo gem install mislav-hanna --source=http://gems.github.com'
end # }}}

capify!

# vi:foldmethod=marker:
