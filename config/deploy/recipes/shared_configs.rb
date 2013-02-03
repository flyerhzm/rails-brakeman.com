before "deploy:update_code", "deploy:update_shared_symlink"

namespace :deploy do
  task :update_shared_symlink do
    run "ln -nfs #{shared_path}/config/*.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/builds #{release_path}/builds"
  end
end

