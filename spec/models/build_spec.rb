require 'rails_helper'

RSpec.describe Build, type: :model do
  it { is_expected.to belong_to(:repository) }

  let(:repository) { create(:repository) }
  subject { create(:build, repository: repository) }

  context "#set_position" do
    it "should get position with 1 for first build" do
      build = create(:build)
      expect(build.position).to eq 1
    end

    it "should get +1 position" do
      repository.reload
      old_position = create(:build, repository: repository).position
      repository.reload
      new_position = create(:build, repository: repository).position
      expect(new_position).to eq old_position + 1
    end
  end

  context "#remove_analyze_file" do
    it "should remove analyze_file after destroy" do
      FileUtils.mkdir_p(Rails.root.join("builds/flyerhzm/test/commit/1234567890/").to_s)
      FileUtils.touch(Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s)
      subject.destroy
      expect(File).not_to be_exist(Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s)
    end
  end

  describe '#analyze_file' do
    subject { super().analyze_file }
    it { is_expected.to == Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s }
  end
  describe '#short_commit_id' do
    subject { super().short_commit_id }
    it { is_expected.to == "1234567" }
  end

  context "#badge_status" do
    it "should be passing" do
      build = build_stubbed(:build, aasm_state: "completed", warnings_count: 0)
      expect(build.badge_state).to eq "passing"
    end

    it "should be failing" do
      build = build_stubbed(:build, aasm_state: "completed", warnings_count: 1)
      expect(build.badge_state).to eq "failing"
    end

    it "should be unknown" do
      build = build_stubbed(:build, aasm_state: "failed")
      expect(build.badge_state).to eq "unknown"

      build = build_stubbed(:build, aasm_state: "scheduled")
      expect(build.badge_state).to eq "unknown"

      build = build_stubbed(:build, aasm_state: "running")
      expect(build.badge_state).to eq "unknown"
    end
  end

  context "#run!" do
    let(:build) { create :build }

    it "should trigger AnalyzeBuildJob" do
      expect {
        build.run!
      }.to have_enqueued_job(AnalyzeBuildJob)
    end
  end
end
