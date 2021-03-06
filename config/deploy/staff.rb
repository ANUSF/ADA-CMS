$:.unshift(File.join(ENV['rvm_path'], 'lib'))
require 'rvm/capistrano'

set :rvm_bin_path, '/usr/local/rvm/bin'
set :rvm_ruby_string, 'ruby-1.9.2-p180'

#role :web, "web3.nci.org.au"
#role :app, "web3.nci.org.au"
#role :db,  "web3.nci.org.au", :primary => true

role :web, "web3.mgmt"
role :app, "web3.mgmt"
role :db,  "web3.mgmt", :primary => true

set :user,        "d10web"
set :use_sudo,    false
set :deploy_to,   "/data/httpd/Rails/ADA-CMS"

# used by migrations:
set :rails_env, "staff"

after 'deploy:update', :symlink_resources

task :symlink_resources, :roles => :app do
  run "ln -nfs /projects_qfs/d10/assda/publish/cms-resources/ #{current_path}/public/resources"
end
