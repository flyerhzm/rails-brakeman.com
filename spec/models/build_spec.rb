require 'spec_helper'

describe Build do
  it { should belong_to(:repository) }

  before { skip_repository_callbacks }

  let(:repository) { create(:repository) }
  subject { create(:build, repository: repository) }

  context "#set_position" do
    it "should get position with 1 for first build" do
      build = create(:build)
      build.position.should == 1
    end

    it "should get +1 position" do
      repository.reload
      old_position = create(:build, repository: repository).position
      repository.reload
      new_position = create(:build, repository: repository).position
      new_position.should == old_position + 1
    end
  end

  context "#remove_analyze_file" do
    it "should remove analyze_file after destroy" do
      FileUtils.mkdir_p(Rails.root.join("builds/flyerhzm/test/commit/1234567890/").to_s)
      FileUtils.touch(Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s)
      subject.destroy
      File.should_not be_exist(Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s)
    end
  end

  its(:analyze_file) { should == Rails.root.join("builds/flyerhzm/test/commit/1234567890/brakeman.html").to_s }
  its(:short_commit_id) { should == "1234567" }

  context "#badge_status" do
    it "should be passing" do
      build = build_stubbed(:build, aasm_state: "completed", warnings_count: 0)
      build.badge_state.should == "passing"
    end

    it "should be failing" do
      build = build_stubbed(:build, aasm_state: "completed", warnings_count: 1)
      build.badge_state.should == "failing"
    end

    it "should be unknown" do
      build = build_stubbed(:build, aasm_state: "failed")
      build.badge_state.should == "unknown"

      build = build_stubbed(:build, aasm_state: "scheduled")
      build.badge_state.should == "unknown"

      build = build_stubbed(:build, aasm_state: "running")
      build.badge_state.should == "unknown"
    end
  end

  context "#run!" do
    before do
      @build = create(:build)
      @build.run!
    end

    it "should fetch remote git and analyze" do
      build_analyze_success

      @build.reload
      @build.aasm_state.should == "completed"
    end

    it "should fail" do
      build_analyze_failure

      @build.reload
      @build.aasm_state.should == "failed"
    end
  end
end
