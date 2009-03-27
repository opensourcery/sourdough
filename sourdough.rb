#
# Sourdough app generator for Ruby on Rails 2.3.2.
#

app_name = File.split(root).last

gem 'thoughtbot-shoulda', :lib => false, :source => "http://gems.github.com"
gem 'webrat',             :lib => false, :source => "http://gems.github.com"
gem 'mislav-hanna',       :lib => false, :source => "http://gems.github.com"
gem 'modelfactory',       :lib => false
gem 'unit_record',        :lib => false
gem 'unit_controller',    :lib => false

rake "gems:install", :sudo => true

git :init

plugin 'annotate_models',        :git => 'git://github.com/rotuka/annotate_models.git',        :submodule => true
plugin 'assert_valid_markup',    :git => 'git://github.com/wireframe/assert_valid_markup.git', :submodule => true
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git',  :submodule => true
plugin 'file_column',            :git => 'git://github.com/kch/file_column.git',               :submodule => true
plugin 'spider_test',            :git => 'git://github.com/courtenay/spider_test.git',         :submodule => true
plugin 'sourdough',              :git => '-b rails2.3 git://github.com/zenhob/sourdough.git',  :submodule => true

git :submodule => 'init'

capify!

environment %{
# Configure exception notification by email
#ExceptionNotifier.exception_recipients = %w[ dev@example.com ]
}, :env => 'production'

# Sourdough setup {{{
environment %{
  config.plugins = [ :sourdough, :all ]
}
file 'config/email.yml.example', %{
from_address: test@example.com
}
run 'cp vendor/plugins/sourdough/README README'
run 'mkdir -p db/migrate'
run 'cp vendor/plugins/sourdough/db/migrate/*.rb db/migrate'
run 'rm -rf public/images public/javascripts public/stylesheets'
run 'cp -r vendor/plugins/sourdough/assets/* public'
run 'mkdir -p config/initializers'
run 'cp -r vendor/plugins/sourdough/config/initializers/* config/initializers'
# }}}

# Delete unnecessary files {{{
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/robots.txt'
# }}}

# Test setup # {{{
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

# Example database config {{{
run 'rm config/database.yml'
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

# Test helpers {{{
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

file 'test/integration/integration_test_helper.rb', %{
require File.dirname(__FILE__) + '/../test_helper.rb'
require 'webrat'
}
# }}}

# Enable the hanna RDoc template {{{
gsub_file "Rakefile", /(#{Regexp.escape("require 'rake/rdoctask'")})/ do |match|
  "require 'hanna/rdoctask'"
end
# }}}

# Git setup and initial commit {{{
run 'rm -rf tmp'
run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
file '.gitignore', %{
tmp
log
db/*.db
db/*.sqlite3
db/schema.rb
*.sw[pon]
*~
.DS_Store
doc/api
doc/app
config/database.yml
config/email.yml
}

git :add => "."
git :commit => "-a -m 'Initial commit'"
# }}}

# Helpfully copy the config templates for the developer,
# this should always be done after .gitignore is created.
run 'cp config/database.yml.example config/database.yml'
run 'cp config/email.yml.example config/email.yml'

# vi:foldmethod=marker:
