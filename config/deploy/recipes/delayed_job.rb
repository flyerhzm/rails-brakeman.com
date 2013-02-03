require "delayed/recipes"

role :delayed_job, 'db.rails-brakeman.com'
set :delayed_job_server_role, :delayed_job

before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"
