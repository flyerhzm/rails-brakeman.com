require 'spec_helper'

describe BuildsController do
  before do
    stubs_current_user
    @repository = build_stubbed(:repository, name: "rails-brakeman.com", user: @user)
    add_ability
  end

  context "GET :show" do
    context "with ability" do
      before do
        @build = build_stubbed(:build)
        builds = []
        @repository.expects(:builds).returns(builds)
        builds.expects(:find).with(@build.id.to_s).returns(@build)

        @ability.can :read, Build
      end

      it "should redirect with repository_id" do
        Repository.expects(:find).with(@repository.id.to_s).returns(@repository)
        get :show, id: @build.id, repository_id: @repository.id
        response.should redirect_to("/flyerhzm/rails-brakeman.com/builds/#{@build.id}")
      end

      it "should assign build with owner_name and repository_name" do
        Repository.expects(:where).with(github_name: "flyerhzm/rails-brakeman.com").returns(stub('repositories', first: @repository))

        get :show, id: @build.id, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
        response.should be_ok
        assigns(:build).should == @build
      end
    end

    it "should no access if repository is non visible" do
      @repository = build_stubbed(:repository, visible: false)
      Repository.expects(:where).with(github_name: "flyerhzm/rails-brakeman.com").returns(stub('repositories', first: @repository))
      @build = build_stubbed(:build)
      builds = []
      @repository.expects(:builds).returns(builds)
      builds.expects(:find).with(@build.id.to_s).returns(@build)

      get :show, id: @build.id, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should_not be_ok
    end

    it "should render 404 if owner_name or repository_name does not exist" do
      Repository.expects(:where).with(github_name: "flyerhzm/rails-brakeman.com").returns(stub('repositories', first: nil))

      get :show, id: 1, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should be_not_found
    end
  end

  context "GET :index" do
    it "should redirect with repository_id" do
      Repository.expects(:find).with(@repository.id.to_s).returns(@repository)

      @ability.can :read, Build
      get :index, repository_id: @repository.id
      response.should redirect_to("/flyerhzm/rails-brakeman.com/builds")
    end

    it "should assign builds" do
      Repository.expects(:where).with(github_name: "flyerhzm/rails-brakeman.com").returns(stub('repositories', first: @repository))

      @build1 = build_stubbed(:build)
      @build2 = build_stubbed(:build)
      @repository.expects(:builds).returns(stub('builds', completed: [@build1, @build2]))

      @ability.can :read, Build
      get :index, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should be_ok
      assigns(:builds).should == [@build1, @build2]
    end

    it "should render 404 if owner_name or repository_name does not exist" do
      Repository.expects(:where).with(github_name: "flyerhzm/rails-brakeman.com").returns(stub('repositories', first: nil))

      get :index, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      response.should be_not_found
    end
  end
end
