# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many :builds }
  it { is_expected.to belong_to :user }

  context "#sync_github" do
    before do
      User.current = create(:user)
      allow_any_instance_of(Repository).to receive(:sync_github).and_call_original
      stub_request(:get, "https://api.github.com/repos/railsbp/railsbp.com").
        to_return(headers: { "Content-Type": "application/json" }, body: File.new(Rails.root.join("spec/fixtures/repository.json")))
    end

    subject { create(:repository, github_name: "railsbp/railsbp.com") }

    describe '#html_url' do
      subject { super().html_url }
      it { should == "https://github.com/railsbp/railsbp.com" }
    end
    describe '#git_url' do
      subject { super().git_url }
      it { should == "git://github.com/railsbp/railsbp.com.git" }
    end
    describe '#ssh_url' do
      subject { super().ssh_url }
      it { should == "git@github.com:railsbp/railsbp.com.git" }
    end
    describe '#name' do
      subject { super().name }
      it { should == "railsbp.com" }
    end
    describe '#description' do
      subject { super().description }
      it { should == "railsbp.com" }
    end
    describe '#private' do
      subject { super().private }
      it { is_expected.to be_truthy }
    end
    describe '#fork' do
      subject { super().fork }
      it { is_expected.to be_falsey }
    end
    describe '#github_id' do
      subject { super().github_id }
      it { should == 2860164 }
    end
  end

  context "stub callbacks" do
    subject { create(:repository) }

    context "#clone_url" do
      it "should get ssh_url if private is true" do
        subject.private = true
        expect(subject.clone_url).to eq subject.ssh_url
      end

      it "should get git_url if private is false" do
        subject.private = false
        expect(subject.clone_url).to eq subject.git_url
      end
    end

    context "#generate_build" do
      it "should call run! for new build" do
        expect_any_instance_of(Build).to receive(:run!)
        subject.generate_build("develop", {"id" => "9876543210", "message" => "commit message"})
      end

      it "should do nothing for nil commit" do
        expect(subject.generate_build("develop", nil)).to be_nil
      end
    end
  end
end
