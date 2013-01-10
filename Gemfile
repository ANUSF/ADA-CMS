source 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.19'

gem "pg"
gem "mysql2"

gem 'inkling', :git => "git://github.com/tfw/inkling.git", :tag => "ada_release"
#gem 'inkling', :path => "/Users/nicholas/code/src/tfw/inkling"

gem "devise", ">= 1.2.0"
gem 'devise_openid_authenticatable', '~> 1.0.0'

if ENV['GEMS_LOCAL'] and File.exist? ENV['GEMS_LOCAL']
  gem 'openid_client', '~> 0.1.8', :path => "#{ENV['GEMS_LOCAL']}/openid_client"
else
  gem 'openid_client', :git => "git://github.com/ANUSF/OpenID-Client-Engine.git"
end

gem 'inherited_resources'
gem 'formtastic'
gem 'ckeditor' , :git => 'git://github.com/cjheath/rails-ckeditor.git', :branch => 'rails3'
gem 'yaml_db'
gem 'nokogiri'
gem 'jquery-rails', '>= 0.2.6' 
gem 'capistrano-ext'
gem 'will_paginate', ">=3.0pre"
gem 'paperclip', ">=2.3"
gem 'ratom'
gem 'sunspot_rails', '>=1.2.1'
gem 'mongrel', '~> 1.2.0.pre2'
gem 'httparty'
gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions'
gem 'columnize', '~> 0.3.4'

group :staff, :public do
	gem 'newrelic_rpm'
end

group :development, :test do
	gem 'ruby-debug-base19', "0.11.25"
	gem 'ruby-debug19'
	gem "mocha"
	gem "rspec-rails"
	gem "rspec-core", ">= 2.6.4"
	gem 'capybara'
	gem 'gemcutter', '>= 0.6.1'
	gem "autotest"
	gem "database_cleaner"
	gem 'steak', '>= 1.0.0.rc.1'
	gem 'faker', '>=0.9.5'
 	gem 'machinist' , '>= 1.0.6'
	gem 'capistrano'
	gem 'selenium-webdriver', '>= 0.2.1'
  	gem 'simplecov', '>= 0.4.0', :require => false, :group => :test
  	gem 'linecache19', '~>0.5.11'
end