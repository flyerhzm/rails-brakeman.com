module Support
  module BuildHelper
    def build_analyze_success
      path = Rails.root.join("builds/flyerhzm/test/commit/1234567890").to_s
      File.expects(:exist?).with(path).returns(false)
      FileUtils.expects(:mkdir_p).with(path)
      FileUtils.expects(:cd).with(path)

      Git.expects(:clone).with("git://github.com/flyerhzm/test.git", "test")
      Dir.expects(:chdir).with("test")

      checks = stub
      checks.expects(:all_warnings).returns([])
      tracker = stub
      tracker.expects(:checks).returns(checks)
      Brakeman.expects(:run).
               with(:app_path => "#{path}/test", output_formats: :html, output_files: ["#{path}/brakeman.html"]).
               returns(tracker)

      Build.any_instance.expects(:remove_brakeman_header)
      FileUtils.expects(:rm_rf).with("#{path}/test")
      work_off
    end

    def build_analyze_failure
      File.expects(:exist?).raises()
      exception_notification = stub
      ExceptionNotifier::Notifier.expects(:background_exception_notification).returns(exception_notification)
      exception_notification.expects(:deliver)
      work_off
    end
  end
end
