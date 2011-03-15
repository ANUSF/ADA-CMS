set :application, "staging"

role :web, "testada"                          # Your HTTP server, Apache/etc
role :app, "testada"                          # This may be the same as your `Web` server
role :db,  "testada", :primary => true # This is where Rails migrations will run

set :rails_env, "test"

set :deploy_to,   "/data"

set :user,        "deploy"
set :use_sudo,    true
set :deploy_to,   "/data"

