require 'bundler/capistrano'
require 'capistrano/ext/multistage'

def rake(cmd, options={}, &block)
  c = "cd #{current_path} && bundle exec rake RAILS_ENV=#{rails_env} #{cmd}"
  run c, options, &block
end

set :application, "Australian Data Archives Website"
set :repository,  'git@github.com:ANUSF/ADA-CMS.git'

set :scm, :git
set :deploy_via, :remote_cache

# role :web, "ada"                          # Your HTTP server, Apache/etc
# role :app, "ada"                          # This may be the same as your `Web` server
# role :db,  "ada", :primary => true # This is where Rails migrations will run

set :user,        "deploy"
# set :use_sudo,    true  #let's see how far we can get without this
set :deploy_to,   "/data"

default_run_options[:pty] = true
default_run_options[:tty] = true

ssh_options[:paranoid] = false
ssh_options[:port] = 22
ssh_options[:forward_agent] = true
ssh_options[:compression] = false

# set :branch, "master"

# The restart procedure for Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

set(:branch) do
  Capistrano::CLI.ui.ask "Open the hatch door please HAL: (specify a tag name to deploy):"
end

after 'deploy:setup', :create_extra_dirs
after 'deploy:setup', :copy_secrets

before 'deploy:update_code', :echo_ruby_env

after 'deploy:update', :symlinks
after 'deploy:update', :deploy_log
after 'deploy:update', :refresh_theme

desc "create additional shared directories during setup"
task :create_extra_dirs, :roles => :app do
  run "mkdir -p #{shared_path}/inkling"
  run "mkdir -p #{shared_path}/resources"
  run "mkdir -p #{shared_path}/solr/data"
end

desc "copy the secret configuration file to the server"
task :copy_secrets, :roles => :app do
  prompt = "Specify a secrets.rb file to copy to the server:"
  path = Capistrano::CLI.ui.ask prompt
  put File.read("#{path}"), "#{shared_path}/secrets.rb", :mode => 0600
end

task :echo_ruby_env do
  puts "Checking ruby env ..."
  run "ruby -v"
  run "export RAILS_ENV='#{rails_env}'"
end

task :symlinks, :roles => :app do
  run "ln -nfs #{shared_path}/inkling #{current_path}/tmp/"
  run "ln -nfs #{shared_path}/resources #{current_path}/public/"
  run "ln -nfs #{shared_path}/secrets.rb #{current_path}/config/initializers"
  run "cd #{current_path}/config; ln -nfs database-deploy.yml database.yml"
end

task :deploy_log, :roles => :app do
  run "touch #{current_path}/tmp/deploy-log.txt"
  run "echo \"Deployed #{branch} at #{Time.now.strftime('%Y-%m-%d %I:%M')}\" > #{current_path}/tmp/deploy-log.txt"
end

task :refresh_theme, :roles => :app do
  rake "install_theme"
end

namespace :solr do
  task :start do
    rake 'sunspot:solr:start'
  end
  task :stop do
    rake 'sunspot:solr:stop'
  end
  task :reindex do
    rake 'sunspot:reindex'
  end
end

namespace :apache do
  task :start do
    sudo "/etc/init.d/httpd start"
  end
  task :stop do
    sudo "/etc/init.d/httpd stop"
  end
  task :restart do
    sudo "/etc/init.d/httpd restart"
  end
end

before 'postgres:pull', 'apache:stop'
after 'postgres:pull', 'apache:start'

namespace :postgres do
  task :pull do
    source_env = Capistrano::CLI.ui.ask "Specify source environment:"
    rake "postgres:pull source=#{source_env}"
  end
end
