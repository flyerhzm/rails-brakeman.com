require 'spec_helper'

describe HeaderCell do
  context "cell rendering" do

    context "rendering display without user" do
      subject { render_cell(:header, :display, nil) }

      it { should have_link("Rails Brakeman") }
      it { should have_link("Home") }
      it { should have_link("About") }
      it { should have_link("Contact") }
      it { should have_link("Sign in with Github") }
    end

    context "rendering display with user" do
      let(:user) { FactoryGirl.build_stubbed(:user) }
      subject { render_cell(:header, :display, user) }

      it { should have_link("Create Repository") }
      it { should have_link("Sign out") }
    end

    context "rendering display with user has repositories" do
      let(:user) { FactoryGirl.build_stubbed(:user) }
      subject { render_cell(:header, :display, user) }
      before do
        @repository1 = FactoryGirl.build_stubbed(:repository)
        @repository2 = FactoryGirl.build_stubbed(:repository)
        user.stubs(:repositories).returns([@repository1, @repository2])
      end

      it { should have_content("Select your repositories") }
      it { should have_link(@repository1.name) }
      it { should have_link(@repository2.name) }
    end
  end


  context "cell instance" do
    subject { cell(:header) }
    it { should respond_to(:display) }
  end
end
