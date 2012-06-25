require "spec_helper"

describe UserMailer do
  before { skip_repository_callbacks }

  context "#notify_build_success" do
    before do
      @user = FactoryGirl.create(:user, email: "flyerhzm@gmail.com", nickname: "flyerhzm")
      @repository = FactoryGirl.create(:repository, github_name: "flyerhzm/rails-brakeman.com", name: "rails-brakeman.com", user: @user)
      @build = FactoryGirl.create(:build, repository: @repository, last_commit_id: "123456789", branch: "develop", last_commit_message: "hello", duration: 20, warnings_count: 2)
    end

    subject { UserMailer.notify_build_success(@build) }
    it { should deliver_to("flyerhzm@gmail.com") }
    it { should have_subject("[rails-brakeman] flyerhzm/rails-brakeman.com build #1 warnings count 2") }
    it { should have_body_text("flyerhzm/rails-brakeman.com") }
    it { should have_body_text("Build #1") }
    it { should have_body_text("Warnings count") }
    it { should have_body_text("<td>2</td>") }
    it { should have_body_text("<a href=\"http://localhost:3000/flyerhzm/rails-brakeman.com/builds/#{@build.id}\">http://localhost:3000/flyerhzm/rails-brakeman.com/builds/#{@build.id}</a>") }
    it { should have_body_text("1234567 (develop)") }
    it { should have_body_text("hello") }
    it { should have_body_text("20 secs") }
  end

  context "#notify_repository_privacy" do
    before do
      @user = FactoryGirl.create(:user, email: "flyerhzm@gmail.com")
      @repository = FactoryGirl.create(:repository, github_name: "flyerhzm/rails-brakeman.com", user: @user)
    end

    subject { UserMailer.notify_repository_privacy(@repository) }
    it { should deliver_to("flyerhzm@gmail.com") }
    it { should have_subject("[rails-brakeman] private repository flyerhzm/rails-brakeman.com on rails-brakeman.com") }
    it { should have_body_text("We are appreciated that you are using rails-brakeman.com") }
    it { should have_body_text("your repository flyerhzm/rails-brakeman.com is a private repository on github") }
    it { should have_body_text("<a href=\"https://github.com/flyerhzm/rails-brakeman.com\">fork rails-brakeman.com on github</a>") }
    it { should have_body_text("<a href=\"mailto:contact-us@rails-brakeman.com\">contact us</a>") }
  end
end
