set :user, "danbooru"
set :rails_env, "production"
server "iratu.pro", :roles => %w(web app db), :primary => true, :user => "danbooru"
