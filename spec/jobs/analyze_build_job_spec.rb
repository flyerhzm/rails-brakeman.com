require 'rails_helper'

RSpec.describe AnalyzeBuildJob do
  let(:build) { create :build, aasm_state: 'running' }

  context 'success' do
    before do
      path = Rails.root.join('builds/flyerhzm/test/commit/1234567890').to_s
      expect(File).to receive(:exist?).with(path).and_return(false)
      expect(FileUtils).to receive(:mkdir_p).with(path)
      expect(FileUtils).to receive(:cd).with(path)

      expect(Git).to receive(:clone).with('git://github.com/flyerhzm/test.git', 'test')
      expect(Dir).to receive(:chdir).with('test')

      checks = double(:checks, all_warnings: [])
      tracker = double(:tracker, checks: checks)
      expect(Brakeman).to receive(:run)
        .with(app_path: "#{path}/test", output_formats: :html, output_files: ["#{path}/brakeman.html"])
        .and_return(tracker)

      expect_any_instance_of(Build).to receive(:remove_brakeman_header)
      expect(FileUtils).to receive(:rm_rf).with("#{path}/test")
    end

    it 'should fetch remote git and analyze' do
      AnalyzeBuildJob.new.perform(build.id)
      expect(build.reload.aasm_state).to eq 'completed'
    end
  end

  context 'failure' do
    before do
      expect(File).to receive(:exist?).and_raise
      expect(Rollbar).to receive(:error)
    end

    it 'should fail' do
      AnalyzeBuildJob.new.perform(build.id)
      expect(build.reload.aasm_state).to eq 'failed'
    end
  end
end
