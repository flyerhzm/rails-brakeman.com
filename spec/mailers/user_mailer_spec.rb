require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  context "#notify_build_success" do
    before do
      @user = create(:user, email: "flyerhzm@gmail.com", nickname: "flyerhzm")
      @repository = create(:repository, github_name: "flyerhzm/rails-brakeman.com", name: "rails-brakeman.com", user: @user)
      @build = create(:build, repository: @repository, last_commit_id: "123456789", branch: "develop", last_commit_message: "hello", duration: 20, warnings_count: 2)
    end

    subject { UserMailer.notify_build_success(@build) }
    it { is_expected.to deliver_to("flyerhzm@gmail.com") }
    it { is_expected.to have_subject("[rails-brakeman] flyerhzm/rails-brakeman.com build #1 warnings count 2") }
    it { is_expected.to have_body_text("flyerhzm/rails-brakeman.com") }
    it { is_expected.to have_body_text("Build #1") }
    it { is_expected.to have_body_text("Warnings count") }
    it { is_expected.to have_body_text("<td>2</td>") }
    it { is_expected.to have_body_text("<a href=\"http://localhost:3000/flyerhzm/rails-brakeman.com/builds/#{@build.id}\">http://localhost:3000/flyerhzm/rails-brakeman.com/builds/#{@build.id}</a>") }
    it { is_expected.to have_body_text("1234567 (develop)") }
    it { is_expected.to have_body_text("hello") }
    it { is_expected.to have_body_text("20 secs") }
  end
end
