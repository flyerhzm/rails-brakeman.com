require 'spec_helper'

describe BuildsController do
  before do
    @user = FactoryGirl.build_stubbed(:user, nickname: "flyerhzm")
    controller.stubs(:current_user).returns(@user)
    @repository = FactoryGirl.build_stubbed(:repository)
    Repository.stubs(:find).with(@repository.id.to_s).returns(@repository)
  end

  context "GET :show" do
    it "should assign build" do
      build = FactoryGirl.build_stubbed(:build)
      @repository.expects(:builds).returns(stub('build', find: build))
      get :show, id: build.id, repository_id: @repository.id
      response.should be_ok
      assigns(:build).should == build
    end
  end

  context "GET :index" do
    it "should assign builds" do
      build1 = FactoryGirl.build_stubbed(:build)
      build2 = FactoryGirl.build_stubbed(:build)
      @repository.expects(:builds).returns([build1, build2])
      get :index, repository_id: @repository.id
      response.should be_ok
      assigns(:builds).should == [build1, build2]
    end
  end
end
