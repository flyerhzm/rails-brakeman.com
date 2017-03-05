set :stage, :production

role :web, %w{deploy@xinminlabs.com}
role :app, %w{deploy@xinminlabs.com}
role :db,  %w{deploy@xinminlabs.com}

server 'xinminlabs.com', user: 'deploy', roles: %w{web app db}, port: 12222
