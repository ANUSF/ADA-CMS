$:.unshift(File.join(ENV['rvm_path'], 'lib'))
require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.2-p180'
#set :rvm_type, :user

set :application, "staging"

role :web, "web2.mgmt"
role :app, "web2.mgmt"
role :db,  "web2.mgmt", :primary => true

set :rails_env, "production"

set :user,        "oxd900"
#set :use_sudo,    true
set :use_sudo,    false
set :deploy_to,   "/data/httpd/Rails/ADA-CMS"

set :database_config_path, "#{ENV['HOME']}/etc/ada-cms/web2"