require 'spec_helper'

describe BuildsController do
  before do
    stubs_current_user

    @repository = FactoryGirl.build_stubbed(:repository, name: "rails-brakeman.com", user: @user)
    Repository.stubs(:find).with(@repository.id.to_s).returns(@repository)

    add_ability
  end

  context "GET :show" do
    context "with ability" do
      before do
        @build = FactoryGirl.build_stubbed(:build)
        builds = []
        @repository.expects(:builds).returns(builds)
        builds.expects(:find).with(@build.id.to_s).returns(@build)

        @ability.can :read, Build
      end

      it "should redirect with repository_id" do
        get :show, id: @build.id, repository_id: @repository.id
        response.should redirect_to("/flyerhzm/rails-brakeman.com/builds/#{@build.id}")
      end

      it "should assign build with user_name and repository_name" do
        expects_user_and_repository

        get :show, id: @build.id, user_name: "flyerhzm", repository_name: "rails-brakeman.com"
        response.should be_ok
        assigns(:build).should == @build
      end
    end

    it "should no access if repository is non visible" do
      @repository = FactoryGirl.build_stubbed(:repository, visible: false)
      expects_user_and_repository
      @build = FactoryGirl.build_stubbed(:build)
      builds = []
      @repository.expects(:builds).returns(builds)
      builds.expects(:find).with(@build.id.to_s).returns(@build)

      get :show, id: @build.id, user_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should_not be_ok
    end
  end

  context "GET :index" do
    it "should redirect with repository_id" do
      @repository.expects(:builds).returns(stub('builds', completed: []))

      @ability.can :read, Build
      get :index, repository_id: @repository.id
      response.should redirect_to("/flyerhzm/rails-brakeman.com/builds")
    end

    it "should assign builds" do
      expects_user_and_repository

      @build1 = FactoryGirl.build_stubbed(:build)
      @build2 = FactoryGirl.build_stubbed(:build)
      @repository.expects(:builds).returns(stub('builds', completed: [@build1, @build2]))

      @ability.can :read, Build
      get :index, user_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should be_ok
      assigns(:builds).should == [@build1, @build2]
    end
  end
end
