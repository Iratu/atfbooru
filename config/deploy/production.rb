set :user, "danbooru"
set :rails_env, "production"
set :delayed_job_workers, 12
append :linked_files, ".env.production"
server "localhost", :roles => %w(web app db), :primary => true, :user => "danbooru"
set :linked_files, fetch(:linked_files, []).push(".env.production")
set :rbenv_path, "/home/danbooru/.rbenv"

set :newrelic_appname, "Danbooru"
after "deploy:finished", "newrelic:notice_deployment"