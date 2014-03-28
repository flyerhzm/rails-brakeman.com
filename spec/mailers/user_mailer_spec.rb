require "spec_helper"

describe UserMailer do
  before { skip_repository_callbacks }

  context "#notify_build_success" do
    before do
      @user = create(:user, email: "flyerhzm@gmail.com", nickname: "flyerhzm")
      @repository = create(:repository, github_name: "flyerhzm/rails-brakeman.com", name: "rails-brakeman.com", user: @user)
      @build = create(:build, repository: @repository, last_commit_id: "123456789", branch: "develop", last_commit_message: "hello", duration: 20, warnings_count: 2)
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
end
