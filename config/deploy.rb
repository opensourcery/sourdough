require File.expand_path(File.dirname(__FILE__) + "/deploy_local")

# Ask for the SVN password if it is not set
unless defined? svn_password
  set :svn_password, Proc.new {  Capistrano::CLI.password_prompt('SVN Password: ') }
end

# Path to rake on remote server
set :rake, "/var/lib/gems/1.8/bin/rake"

# Export the SVN repository so we don't leave .svn files around
set :checkout, "export"

# Target directory for the application on the web and app servers.
set :deploy_to, "/var/www/rubyapp"

# Login user for ssh.
set :user, "developer"

# URL of your source repository.
set :repository, "https://prefect.opensourcery.com:444/svn/osourcery/lib/sourdough/trunk"

# Automatically symlink these directories from curent/public to shared/public.
set :app_symlinks, %w{photos}

case ENV["SERVER"]

  when "production"
    set :primary_server, "name.prod.opensourcery.com"
    ssh_options[:keys] = %w(~/.ssh/ida_dsa_sysnet)

  when "localhost-production"
    set :primary_server, "localhost"
    ssh_options[:port] = ENV["SSH_PORT"] || 2227
    ssh_options[:keys] = %w(~/.ssh/ida_dsa_sysnet)

  when "demo"
    set :primary_server, "name.test.opensourcery.com"

  when "localhost-demo"
    set :primary_server, "localhost"
    ssh_options[:port] = ENV["SSH_PORT"] || 2227

  else
    print "USAGE: cap <remote:task> SERVER=server\n\n"

    print "You need to specify the SERVER environment variable to one of the following\n"
    print "targets:\n\n"

    print " * production - production server\n"
    print " * demo - demo server\n"

    print "If you are outside of Swamp, you will need to tunnel to the demo server:\n"
    print " * to reach the test/demo servers:\n"
    print "   * ssh -fN -L SSH_PORT:descant.opensourcery.com:22 oolon\n"
    print "(where SSH_PORT should be replaced with the port you intend to use on your\n"
    print "local workstation) and then you will be able to do one of the following:\n\n"

    print " * localhost-demo - tunneled access to the demo server from outside of swamp\n"
    print "                    (defaults to port 2231)\n"

    print " * localhost-production - tunneled access to the production server from outside of swamp\n"
    print "                    (defaults to port 2231)\n"

    print "These last three options also expect that the SSH_PORT environment variable has\n"
    print "been set if you intend to use something besides the default ports listed above.\n"
    exit

end

# Modify these values to execute tasks on a different server.
role :web, primary_server
role :app, primary_server
role :db,  primary_server, :primary => true

desc "Restart the web server"
task :restart, :roles => :web do
  sudo "/etc/init.d/mongrel_cluster stop"
  sudo "/etc/init.d/mongrel_cluster start"
end

case ENV['SERVER']

  when "production", "localhost-production"
    set :db_user, production_db_user
    set :db_password, production_db_password
    set :db_host, production_db_host
    set :db_name, production_db_name
    set :from_address, production_from_address

  when "demo", "localhost-demo"
    set :db_user, development_db_user
    set :db_password, development_db_password
    set :db_host, development_db_host
    set :db_name, development_db_name
    set :from_address, development_from_address

  else
    print "Error processing ENV['SERVER']"
    exit

end

# Inspiration from: http://www.jvoorhis.com/articles/2006/07/07/managing-database-yml-with-capistrano
desc "Create database.yml in the deployed instance."
task :after_update_code, :roles => :app do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/email.yml #{release_path}/config/email.yml"
end

desc "Create database.yml and email.yml after server setup"
task :after_setup, :roles => :app do
  create_database_configuration
  create_email_configuration
end

desc "Make sure tmp/ has the correct permissions"
task :before_restart, :roles => :app do
  # NOTE: I am setting up the permissions because some rails plugins will create files and directories
  # after the code update and before the restart tasks
  setup_permissions
end

desc "Create database.yml in the deployed instance."
task :create_database_configuration do
  raise "db_adapter, db_user, db_host, db_password, db_name must be set in config/deploy_local.rb" unless db_adapter and db_host and db_user and db_password and db_name

  database_configuration = render :template => <<-EOF
login: &login
  adapter: <%= db_adapter %>
  host: <%= db_host %>
  username: <%= db_user %>
  password: <%= db_password %>
  encoding: utf8

development:
  database:
  <<: *login

test:
  database:
  <<: *login

production:
  database: <%= db_name %>
  <<: *login
EOF
  run "mkdir -p #{deploy_to}/#{shared_dir}/config"
  database_file = "#{deploy_to}/#{shared_dir}/config/database.yml"
  put database_configuration, database_file
  run "chgrp mongrel #{database_file}"
  run "chmod g+r #{database_file}"
end

desc "Create email.yml in the deployed instance."
task :create_email_configuration do
  raise "from_address must be set in config/deploy_local.rb" unless from_address

  email_configuration = render :template => <<-EOF
from_address: #{from_address}
EOF
  run "mkdir -p #{deploy_to}/#{shared_dir}/config"
  email_file = "#{deploy_to}/#{shared_dir}/config/email.yml"
  put email_configuration, email_file
  run "chmod g+r #{email_file}"
  run "chgrp mongrel #{email_file}"
end

desc "Setup permissions on the deployed instance."
task :setup_permissions do
  tmp_dir = "#{release_path}/tmp"
  run "chgrp -R mongrel #{tmp_dir}"
  run "find #{tmp_dir} -type d | xargs chgrp mongrel"
  run "find #{tmp_dir} -type d | xargs chmod g+rwx"
end

desc "Setup initial server permissions"
task :setup_server_permissions do
  run "chgrp -R mongrel #{shared_path}"
  if app_symlinks
    app_symlinks.each { |link| run "chmod g+rw #{shared_path}/public/#{link}" }
  end
end

desc "Setup public symlink directories"
task :setup_symlinks, :roles => [:app, :web] do
  if app_symlinks
    app_symlinks.each { |link| run "mkdir -p #{shared_path}/public/#{link}" }
  end
end

desc "Link up any public directories."
task :symlink_public, :roles => [:app, :web] do
  if app_symlinks
    app_symlinks.each { |link| run "ln -nfs #{shared_path}/public/#{link} #{current_path}/public/#{link}" }
  end
end

desc "Creates additional symlinks."
task :after_symlink, :roles => [:app, :web] do
  symlink_public
end

task :setup_server do
  setup
  setup_symlinks
  setup_server_permissions
end
