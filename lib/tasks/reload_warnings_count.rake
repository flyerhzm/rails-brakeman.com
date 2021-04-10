namespace :builds do
  task :reload_warnings_count => :environment do
    Build.completed.each do |build|
      body = File.read build.analyze_file
      body =~ %r{<td>Security Warnings</td>\s*<td>(\d*)}
      build.warnings_count = $1.to_i
      build.save
    end
  end
end
