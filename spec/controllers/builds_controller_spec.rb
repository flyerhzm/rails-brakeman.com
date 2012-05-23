require 'spec_helper'

describe BuildsController do
  before do
    @user = FactoryGirl.build_stubbed(:user, nickname: "flyerhzm")
    controller.stubs(:current_user).returns(@user)
    @repository = FactoryGirl.build_stubbed(:repository)
    Repository.stubs(:find).with(@repository.id.to_s).returns(@repository)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stubs(:current_ability).returns(@ability)
  end

  context "GET :show" do
    it "should assign build" do
      @ability.can :read, Build
      build = FactoryGirl.build_stubbed(:build)
      Build.expects(:find).with(build.id.to_s).returns(build)
      get :show, id: build.id, repository_id: @repository.id
      response.should be_ok
      assigns(:build).should == build
    end

    it "should no access if repository is non visible" do
      @repository = FactoryGirl.build_stubbed(:repository, visible: false)
      Repository.stubs(:find).with(@repository.id.to_s).returns(@repository)
      build = FactoryGirl.build_stubbed(:build)
      Build.expects(:find).with(build.id.to_s).returns(build)
      get :show, id: build.id, repository_id: @repository.id
      response.should_not be_ok
    end
  end

  context "GET :index" do
    it "should assign builds" do
      @ability.can :read, Build
      build1 = FactoryGirl.build_stubbed(:build)
      build2 = FactoryGirl.build_stubbed(:build)
      @repository.expects(:builds).returns(stub('builds', completed: [build1, build2]))
      get :index, repository_id: @repository.id
      response.should be_ok
      assigns(:builds).should == [build1, build2]
    end
  end
end
