# frozen_string_literal: true

class AnalyzeBuildJob < ActiveJob::Base
  queue_as :default

  def perform(build_id)
    build = Build.find(build_id)
    repository = build.repository
    begin
      start_time = Time.now
      FileUtils.mkdir_p(build.analyze_path) unless File.exist?(build.analyze_path)
      FileUtils.cd(build.analyze_path)
      g = Git.clone(repository.clone_url, repository.name)
      Dir.chdir(repository.name) { g.reset_hard(build.last_commit_id) }
      tracker = Brakeman.run({
        app_path: "#{build.analyze_path}/#{repository.name}",
        output_formats: :html,
        output_files: [build.analyze_file]
      })
      end_time = Time.now
      build.warnings_count = tracker.checks.all_warnings.size
      build.duration = end_time - start_time
      build.finished_at = end_time
      repository.touch(:last_build_at)
      UserMailer.notify_build_success(build).deliver_now if repository.user_email
      build.remove_brakeman_header
      build.complete!
    rescue => e
      Rollbar.error(e)
      build.fail!
    ensure
      FileUtils.rm_rf("#{build.analyze_path}/#{repository.name}")
    end
  end
end
