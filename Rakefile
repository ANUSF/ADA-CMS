# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

namespace :ada do
  task :rebuild => :environment do
    if ["development", "devs", "test", "staging"].include? Rails.env or `hostname` =~ /\.local/
      ["db:drop", "db:create", "db:migrate", "db:bootstrap", "db:seed", "install_theme", "publish_all"].each do |t|
        Rake::Task[t].execute
      end
    else
      puts "ada:rebuild isn't meant to run on staff, public, or any other production level environment."
    end
  end
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
  for klass in [Page, ArchiveNews, ArchiveStudy, Document, Image, ArchiveCatalog, Inkling::Feed]
    klass.all.each do |content| 
      content.save! 
      puts "#{klass.to_s}-(title #{content.title}): #{content.path.slug}"
    end
  end
end

task :create_feeds => :environment do
  for archive in Archive.all
    Inkling::Feed.create!(:title => "#{archive.name} Atom Feed", :format => "Inkling::Feeds::Atom", :source => "NewsFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
  end
end

task :ensure_menu_items => :environment do
  MenuItem.delete_all
  parent_pages = Page.find_all_by_parent_id(nil)
  parent_pages.each do |page|
    menu_items_for_tree(page)
  end
end

def menu_items_for_tree(page)
  MenuItem.create_from_page(page)
  
  for child in page.children
    menu_items_for_tree(child)
  end 
end

task :reindex => :environment do
  extend TimeInWords
  log = Inkling::Log.create!(:category => "search-index", :text => "Solr began reindexing")
  system("rake sunspot:reindex")
  duration = time_in_words(Time.now, log.created_at)
  Inkling::Log.create!(:category => "search-index", :text => "Solr finished index after #{duration}")
end


task :var_count => :environment do
  Archive.all.each do |archive|
    next if archive.name == "ADA"
    study_ids = archive.studies.collect {|s| s.id}
    study_ids = study_ids.join ","
    study_ids = "(#{study_ids})" 
    puts "#{archive.name}: has #{Variable.count(:conditions => ["study_id in #{study_ids}"])} vars"
  end
end

namespace :postgres do
  dbhost = Secrets::DATABASE_HOST
  dbport = 5432
  dbuser = Secrets::DATABASE_USERNAME
  dbpass = Secrets::DATABASE_PASSWORD

  connection = "-U #{dbuser} --host #{dbhost} -p #{dbport}"

  task :pull => :environment do
    source_db = "adacms_#{ENV['source']}"
    target_db = "adacms_#{Rails.env}"
    filename = "tmp/#{source_db}.tar"

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute

    system "export PGPASSWORD=#{dbpass} &&
      pg_dump -Ft -b #{connection} #{source_db} > #{filename} &&
      pg_restore -O #{connection} -d #{target_db} #{filename} &&
      rm #{filename}"
  end
end

# task :prime_cache => :environment do
#   require 'httparty'
#   include HTTParty
#   Inkling::Path.all.each do |path|
#     get "http://localhost:3000#{path.slug}"
#   end
# end

task :publish_all => :environment do
  u = User.first
  publishables = Page.all + News.all
  publishables.each do |o|
    o.publish!(u)
  end
end

task :destroy_paths => :environment do
  Inkling::Path.delete_all
end



