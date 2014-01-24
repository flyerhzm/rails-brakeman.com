set :output, "/home/deploy/sites/rails-brakeman.com/production/shared/log/cron_log.log"
job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.day, at: '2am' do
  command "backup perform -t rails_brakeman_com"
end
