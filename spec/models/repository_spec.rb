require 'spec_helper'

describe Repository do
  it { should have_many :builds }
  it { should belong_to :user }

  context "#sync_github" do
    before do
      skip_repository_callbacks(:except => :sync_github)
      User.current = FactoryGirl.create(:user)
      repo = File.read(Rails.root.join("spec/fixtures/repository.json").to_s)
      stub_request(:get, "https://api.github.com/repos/railsbp/railsbp.com").to_return(body: repo)
    end

    subject { FactoryGirl.create(:repository, github_name: "railsbp/railsbp.com") }

    its(:html_url) { should == "https://github.com/railsbp/railsbp.com" }
    its(:git_url) { should == "git://github.com/railsbp/railsbp.com.git" }
    its(:ssh_url) { should == "git@github.com:railsbp/railsbp.com.git" }
    its(:name) { should == "railsbp.com" }
    its(:description) { should == "railsbp.com" }
    its(:private) { should be_true }
    its(:fork) { should be_false }
    its(:github_id) { should == 2860164 }
  end

  context "stub callbacks" do
    before { skip_repository_callbacks }

    subject { FactoryGirl.create(:repository) }

    context "#clone_url" do
      it "should get ssh_url if private is true" do
        subject.private = true
        subject.clone_url.should == subject.ssh_url
      end

      it "should get git_url if private is false" do
        subject.private = false
        subject.clone_url.should == subject.git_url
      end
    end

    context "#generate_build" do
      it "should call run! for new build" do
        Build.any_instance.expects(:run!)
        subject.generate_build("develop", {"id" => "9876543210", "message" => "commit message"})
      end
    end
  end
end
