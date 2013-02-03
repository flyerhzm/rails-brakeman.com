after "deploy:create_symlink", "deploy:update_crontab:db"

namespace :update_crontab do
  desc "Update the crontab file on db server"
  task :db, roles: :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab -f config/schedule/db.rb -i rails-brakeman.com-db"
  end
end
