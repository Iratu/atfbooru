set :stages, %w(production development staging)
set :default_stage, "staging"
set :application, "danbooru"
set :repo_url,  "https://github.com/Iratu/atfbooru.git"
set :scm, :git
set :branch, "master"
set :deploy_to, "/var/www/danbooru2"
set :rbenv_ruby, "2.3.1"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
set :branch, ENV.fetch("branch", "master")