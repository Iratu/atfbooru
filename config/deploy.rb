set :stages, %w(production development staging)
set :default_stage, "staging"
set :application, "danbooru"
set :repo_url,  "https://github.com/Iratu/atfbooru.git"
set :deploy_to, "/var/www/danbooru2"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')
set :branch, ENV.fetch("branch", "master")

# skip migrations if files in db/migrate weren't modified
set :conditionally_migrate, true

# run migrations on the primary app server
set :migration_role, :app

set :whenever_roles, :cron

# how long unicorn:legacy_restart (used by deploy:rolling) waits until killing the old unicorn.
set :unicorn_restart_sleep_time, 10
