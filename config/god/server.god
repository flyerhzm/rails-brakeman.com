#!/usr/bin/ruby

app_path = '/home/huangzhi/sites/rails-brakeman.com/production/current'
shared_path = '/home/huangzhi/sites/rails-brakeman.com/production/shared'
ruby_path = '~/.rvm/rubies/ruby-1.9.3-p194/bin/ruby'

God.watch do |w|
  w.name = "rails-brakeman-server"
  w.interval = 60.seconds
  w.start = "cd #{app_path} && bundle exec puma -e production -p 3001 --pid #{app_path}/tmp/pids/#{w.name}.pid"

  w.start_grace = 20.seconds
  w.pid_file = "#{app_path}/tmp/pids/#{w.name}.pid"

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 60.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 10.minutes
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
