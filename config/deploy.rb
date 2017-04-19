set :rvm_type, :user
set :rvm_ruby_version, '2.3.3'
set :rvm_map_bins, %w{gem rake ruby rails bundle sidekiq sidekiqctl}

set :application, "rails-brakeman.com"
set :repo_url,  "git@github.com:flyerhzm/rails-brakeman.com.git"
set :branch, 'master'
set :deploy_to, "/home/deploy/sites/rails-brakeman.com/production"
set :keep_releases, 5

set :linked_files, %w{.env}

set :linked_dirs, %w{log builds tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :rails_env, "production"

set :disallow_pushing, true
