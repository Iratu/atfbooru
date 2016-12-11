set :user, "danbooru"
set :rails_env, "production"
server "127.0.0.1", :roles => %w(web app db), :primary => true, :user => "danbooru"
