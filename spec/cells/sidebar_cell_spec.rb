require 'spec_helper'

describe SidebarCell do
  context "cell rendering" do
    context "rendering display without repositories" do
      subject { render_cell(:sidebar, :display) }

      it { should have_selector("h3", :text => "Public Repositories") }
    end

    context "rendering display with repositories" do
      before do
        @repository1 = FactoryGirl.build_stubbed(:repository)
        @repository2 = FactoryGirl.build_stubbed(:repository)
        repositories = [@repository1, @repository2]
        Repository.expects(:latest).returns(repositories)
        repositories.expects(:limit).returns(repositories)
      end
      subject { render_cell(:sidebar, :display) }

      it { should have_link(@repository1.name) }
      it { should have_link(@repository2.name) }
    end

    context "rendering display with repository has builds" do
      let(:repository) { FactoryGirl.build_stubbed(:repository, builds_count: 2, last_build_at: Time.now) }
      before do
        repositories = [repository]
        Repository.expects(:latest).returns(repositories)
        repositories.expects(:limit).returns(repositories)

        @build1 = FactoryGirl.build_stubbed(:build, position: 1)
        @build2 = FactoryGirl.build_stubbed(:build, position: 2, duration: 10)
        repository.stubs(:builds).returns([@build1, @build2])
      end
      subject { render_cell(:sidebar, :display) }

      it { should have_link("#2") }
      it { should have_content("Duration") }
      it { should have_selector("span", text: "10 secs") }
      it { should have_content("Finished") }
    end
  end


  context "cell instance" do
    subject { cell(:sidebar) }
    it { should respond_to(:display) }
  end
end
