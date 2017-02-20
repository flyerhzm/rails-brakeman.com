after  "deploy:restart", "delayed_job:restart"

namespace :delayed_job do
  task :restart, :roles => :db do
    run "cd #{current_path}; RAILS_ENV=production bundle exec script/delayed_job restart"
  end
end
