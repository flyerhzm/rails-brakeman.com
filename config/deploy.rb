require 'capistrano_colors'
require 'bundler/capistrano'

require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-2.0.0-p648@rails-brakeman.com'

set :application, "rails-brakeman.com"
set :repository,  "git@github.com:flyerhzm/rails-brakeman.com.git"
set :rails_env, "production"
set :deploy_to, "/home/deploy/sites/rails-brakeman.com/production"
set :user, "deploy"
set :use_sudo, false

set :scm, :git

ssh_options[:port] = 12222
ssh_options[:forward_agent] = true

set :rake, "bundle exec rake"

role :web, "rails-brakeman.com"                          # Your HTTP server, Apache/etc
role :app, "rails-brakeman.com"                          # This may be the same as your `Web` server
role :db,  "rails-brakeman.com", primary: true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    migrate
    cleanup
    run "cd #{current_path}; kill -HUP `cat tmp/pids/puma.pid`"
  end
end
