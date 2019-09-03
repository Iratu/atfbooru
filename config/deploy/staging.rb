set :user, "danbooru"
set :rails_env, "staging"
server "danbooru.rori-dl.com", :roles => %w(web app db), :primary => true, :user => "danbooru"
set :linked_files, fetch(:linked_files, []).push(".env.staging")
set :deploy_to, "/var/www/danbooru2"
