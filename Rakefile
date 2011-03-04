# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

namespace :ada do
  # task :rebuild => ["db:drop", "db:create", "restore_postgres", "db:migrate", "db:seed", "install_theme"]
  task :rebuild => ["db:drop", "db:create", "db:load", "db:migrate", "db:seed"]
end

task :restore_postgres do
  system("psql -d ada_#{Rails.env} < ada_data_13_2_2011.out")
end

task :install_theme => :environment do
  Inkling::Theme.install_from_dir("config/theme")
end

#tasks necessary for cruisecontrolrb
task :cruise => [:test_env, :bundler, :environment, "ada:rebuild", :spec]

task :test_env do
  ENV['RAILS_ENV'] = 'test'
end

task :bundler do
  system('bundle install')
end