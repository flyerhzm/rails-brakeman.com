module Support
  module BuildHelper
    def build_analyze_success
      path = Rails.root.join("builds/flyerhzm/test/commit/1234567890").to_s
      expect(File).to receive(:exist?).with(path).and_return(false)
      expect(FileUtils).to receive(:mkdir_p).with(path)
      expect(FileUtils).to receive(:cd).with(path)

      expect(Git).to receive(:clone).with("git://github.com/flyerhzm/test.git", "test")
      expect(Dir).to receive(:chdir).with("test")

      tracker = double(:tracker)
      checks = double(:checks)
      allow(tracker).to receive(:checks).and_return(checks)
      allow(checks).to receive(:all_warnings).and_return([])
      expect(Brakeman).to receive(:run).with(:app_path => "#{path}/test", output_formats: :html, output_files: ["#{path}/brakeman.html"]).and_return(tracker)

      expect_any_instance_of(Build).to receive(:remove_brakeman_header)
      expect(FileUtils).to receive(:rm_rf).with("#{path}/test")
      work_off
    end

    def build_analyze_failure
      expect(File).to receive(:exist?).and_raise
      expect(Rollbar).to receive(:error)
      work_off
    end
  end
end
