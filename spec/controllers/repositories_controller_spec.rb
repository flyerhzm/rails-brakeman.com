require 'spec_helper'

describe RepositoriesController do
  before do
    @user = FactoryGirl.build_stubbed(:user, nickname: "flyerhzm")
    controller.stubs(:current_user).returns(@user)
    Repository.any_instance.stubs(:sync_github)
    @repository = FactoryGirl.build_stubbed(:repository, user: @user)
  end

  context "GET :new" do
    it "should assign repository" do
      get :new
      response.should be_ok
      assigns(:repository).should_not be_nil
    end
  end

  context "POST :create" do
    it "should redirect to edit page if create successfully" do
      controller.stubs(:own_repository?).returns(true)
      controller.stubs(:org_repository?).returns(true)
      post :create, repository: {github_name:"flyerhzm/test"}
      repository = assigns(:repository)
      response.should redirect_to([:edit, repository])
    end

    it "should render new page if create failed" do
      controller.stubs(:own_repository?).returns(true)
      controller.stubs(:org_repository?).returns(true)
      Repository.any_instance.stubs(:save).returns(false)
      post :create, repository: {github_name:"flyerhzm/test"}
      response.should render_template(:new)
    end

    it "should redirect ot new if user is not owner" do
      controller.stubs(:own_repository?).returns(false)
      controller.stubs(:org_repository?).returns(false)
      post :create, repository: {github_name:"flyerhzm/test"}
      response.should redirect_to([:new, :repository])
    end
  end

  context "GET :edit" do
    it "should assign repository" do
      @user.expects(:repositories).returns(stub('repository', find: @repository))
      get :edit, id: @repository.id
      response.should be_ok
      assigns(:repository).should == @repository
    end
  end

  context "PUT :update" do
    it "should redirecrt to edit page if update successfully" do
      @user.expects(:repositories).returns(stub('repository', find: @repository))
      @repository.expects(:update_attributes).returns(true)
      put :update, id: @repository.id
      response.should redirect_to([:edit, @repository])
    end

    it "should render edit page if update failed" do
      @user.expects(:repositories).returns(stub('repository', find: @repository))
      @repository.expects(:update_attributes).returns(false)
      put :update, id: @repository.id
      response.should render_template(:edit)
    end
  end

  context "GET :show" do
    it "shoud assign repository without build" do
      Repository.expects(:find).returns(@repository)
      @repository.expects(:builds).returns(stub('build', last: nil))
      get :show, id: @repository.id
      response.should be_ok
      assigns(:repository).should_not be_nil
    end

    it "should assign build if repository has build" do
      Repository.expects(:find).returns(@repository)
      build = FactoryGirl.build_stubbed(:build)
      @repository.expects(:builds).returns(stub('build', last: build))
      get :show, id: @repository.id
      response.should render_template("builds/show")
      assigns(:build).should_not be_nil
    end
  end

  context "POST :sync" do
    let(:hook_json) { File.read(Rails.root.join("spec/fixtures/github_hook.json")) }
    let(:last_message) {
      {
        "id" => "473d12b3ca40a38f12620e31725922a9d88b5386",
        "url" => "https://github.com/railsbp/rails-bestpractices.com/commit/473d12b3ca40a38f12620e31725922a9d88b5386",
        "author" => {
          "email" => "flyerhzm@gmail.com",
          "name" => "Richard Huang"
        },
        "message" => "copy config yaml files for travis",
        "timestamp" => "2011-12-25T20:36:34+08:00"
      }
    }

    it "should generate build" do
      repository = FactoryGirl.build_stubbed(:repository, html_url: "https://github.com/railsbp/rails-bestpractices.com")
      Repository.expects(:where).with(html_url: "https://github.com/railsbp/rails-bestpractices.com").returns([repository])
      repository.expects(:generate_build).with("master", last_message)
      post :sync, token: "123456789", payload: hook_json, format: 'json'
      response.should be_ok
      response.body.should == "success"
    end

    it "should not generate build if url does not exist" do
      repository = FactoryGirl.build_stubbed(:repository, html_url: "https://github.com/railsbp/rails-bestpractices.com")
      Repository.expects(:where).with(html_url: "https://github.com/railsbp/rails-bestpractices.com").returns([])
      post :sync, token: "123456789", payload: hook_json, format: 'json'
      response.should be_ok
      response.body.should == "not authenticate"
    end
  end
end
