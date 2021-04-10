require 'rails_helper'

RSpec.describe BuildsController, type: :controller do
  before do
    stubs_current_user
    @repository = create(:repository, name: 'rails-brakeman.com', github_name: 'flyerhzm/rails-brakeman.com', user: @user)
    add_ability
  end

  context "GET :show" do
    context "with ability" do
      before do
        @build = create(:build, repository: @repository)

        @ability.can :read, Build
      end

      it "redirects with repository_id" do
        get :show, id: @build.id, repository_id: @repository.id
        expect(response).to redirect_to("/flyerhzm/rails-brakeman.com/builds/#{@build.id}")
      end

      it "assigns build with owner_name and repository_name" do
        get :show, id: @build.id, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
        expect(response).to be_ok
        expect(assigns(:build)).to eq @build
      end
    end

    it "noes access if repository is non visible" do
      @repository.update(visible: false)
      @build = create(:build, repository: @repository)

      get :show, id: @build.id, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      expect(response).not_to be_ok
    end

    it "renders 404 if owner_name or repository_name does not exist" do
      get :show, id: 1, owner_name: "flyerhzm", repository_name: "rails.com"
      expect(response).to be_not_found
    end
  end

  context "GET :index" do
    it "redirects with repository_id" do
      @ability.can :read, Build
      get :index, repository_id: @repository.id
      expect(response).to redirect_to("/flyerhzm/rails-brakeman.com/builds")
    end

    it "assigns builds" do
      @build1 = create(:build, repository: @repository, aasm_state: 'completed')
      @build2 = create(:build, repository: @repository, aasm_state: 'completed')

      @ability.can :read, Build
      get :index, owner_name: "flyerhzm", repository_name: "rails-brakeman.com"
      expect(response).to be_ok
      expect(assigns(:builds)).to eq [@build1, @build2]
    end

    it "renders 404 if owner_name or repository_name does not exist" do
      get :index, owner_name: "flyerhzm", repository_name: "rails.com"
      expect(response).to be_not_found
    end
  end
end
