require 'capistrano_colors'
require 'bundler/capistrano'
require "delayed/recipes"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p125@rails-brakeman.com'
set :rvm_type, :user

set :application, "rails-brakeman.com"
set :repository,  "git@github.com:flyerhzm/rails-brakeman.com.git"
set :rails_env, :production
set :deploy_to, "/home/huangzhi/sites/rails-brakeman.com/production"
set :user, "huangzhi"
set :use_sudo, false

set :scm, :git

set :rake, "bundle exec rake"

role :web, "app.rails-brakeman.com"                          # Your HTTP server, Apache/etc
role :app, "app.rails-brakeman.com"                          # This may be the same as your `Web` server
role :db,  "db.rails-brakeman.com", :primary => true # This is where Rails migrations will run
role :delayed_job, 'db.rails-brakeman.com'
set :delayed_job_server_role, :delayed_job

before "deploy:assets:precompile", "config:init"

before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"

after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

after "deploy:symlink", "deploy:update_crontab:db"

namespace :config do
  task :init do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/github.yml #{release_path}/config/github.yml"
    run "ln -nfs #{shared_path}/config/mailers.yml #{release_path}/config/mailers.yml"
    run "ln -nfs #{shared_path}/builds #{release_path}/builds"
  end
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    migrate
    cleanup
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  namespace :update_crontab do
    desc "Update the crontab file on db server"
    task :db, :roles => :db do
      run "cd #{release_path} && bundle exec whenever --update-crontab -f config/schedule/db.rb -i rails-brakeman.com-db"
    end
  end
end
