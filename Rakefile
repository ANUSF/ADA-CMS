# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'thinking_sphinx/tasks'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => ["db:drop", "db:create", "db:migrate", "db:bootstrap", "db:seed", "install_theme"]
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

task :regenerate_paths => :environment do
  for klass in [Page, News, ArchiveStudy, Document, Image, ArchiveCatalog, Inkling::Feed]
    klass.all.each do |content| 
      puts "#{klass.to_s} - id (#{content.id} - title #{content.title})"
      content.save! 
    end
  end
end

task :create_feeds => :environment do
  for archive in Archive.all
    Inkling::Feed.create!(:title => "#{archive.name} Atom Feed", :format => "Inkling::Feeds::Atom", :source => "NewsFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
  end
end

task :exp => :environment do
  require 'ruby-debug'
  Integrations::ArchiveCatalogs.create_or_update(Nesstar::StatementEJB.find_by_objectId("indigenous"), Archive.indigenous.id)
 
end