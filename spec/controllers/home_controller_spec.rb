require 'spec_helper'

describe HomeController do
  before do
    @user = FactoryGirl.build_stubbed(:user, nickname: "flyerhzm")
    controller.stubs(:current_user).returns(@user)
  end

  context "GET :index" do
    it "should response ok" do
      get :index
      response.should be_ok
    end
  end
end
