set :stages, %w(production development staging)
set :default_stage, "staging"
set :application, "danbooru"
set :repo_url,  "https://github.com/Iratu/atfbooru.git"
set :scm, :git
set :branch, "7c521c7975c99f4c57aa8bbd55793cd9ca323204"
set :deploy_to, "/var/www/danbooru2"
set :rbenv_ruby, "2.3.1"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
