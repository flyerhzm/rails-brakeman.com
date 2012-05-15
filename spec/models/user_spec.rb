require 'spec_helper'

describe User do
  it { should have_many :repositories }

  context ".find_for_github_oauth" do
    before do
      @data = Hashie::Mash.new({
        uid: 12345,
        info: {
          email: 'flyerhzm@gmail.com',
          nickname: 'flyerhzm'
        },
        credentials: {
          token: 'abcdef'
        }
      })
    end

    it "should create a new user if github_uid isn't existed" do
      lambda {
        User.find_for_github_oauth(@data)
      }.should change(User, :count).by(1)
    end

    it "should find the user if github_uid is existed" do
      FactoryGirl.create(:user, github_uid: 12345)
      lambda {
        User.find_for_github_oauth(@data)
      }.should_not change(User, :count)
    end
  end
end
