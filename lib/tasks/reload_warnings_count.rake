namespace :builds do
  task :reload_warnings_count => :environment do
    Build.completed.each do |build|
      body = File.read build.analyze_file
      body =~ /<td>Security Warnings<\/td>\s*<td>(\d*)/
      build.warnings_count = Regexp.last_match(1).to_i
      build.save
    end
  end
end
