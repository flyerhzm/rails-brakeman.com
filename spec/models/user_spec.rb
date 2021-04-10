require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :repositories }

  describe ".find_for_github_oauth" do
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
      expect { User.find_for_github_oauth(@data) }.to change(User, :count).by(1)
    end

    it "should find the user if github_uid is existed" do
      create(:user, github_uid: 12345)
      expect { User.find_for_github_oauth(@data) }.not_to change(User, :count)
    end
  end
end
