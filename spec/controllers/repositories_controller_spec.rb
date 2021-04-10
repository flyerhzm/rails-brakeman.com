require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  before do
    stubs_current_user
    @repository =
      create(:repository, github_name: 'flyerhzm/rails-brakeman.com', name: 'rails-brakeman.com', user: @user)

    add_ability
  end

  context 'GET :new' do
    it 'should assign repository' do
      @ability.can :new, Repository
      get :new
      expect(response).to be_ok
      expect(assigns(:repository)).not_to be_nil
    end
  end

  context 'POST :create' do
    it 'should redirect to edit page if create successfully' do
      @ability.can :create, Repository
      allow(controller).to receive(:own_repository?).and_return(true)
      allow(controller).to receive(:org_repository?).and_return(true)
      post :create, repository: { github_name: 'flyerhzm/test' }
      repository = assigns(:repository)
      expect(response).to redirect_to([:edit, repository])
    end

    it 'should render new page if create failed' do
      @ability.can :create, Repository
      allow(controller).to receive(:own_repository?).and_return(true)
      allow(controller).to receive(:org_repository?).and_return(true)
      allow_any_instance_of(Repository).to receive(:save).and_return(false)
      post :create, repository: { github_name: 'flyerhzm/test' }
      expect(response).to render_template(:new)
    end

    it 'should redirect ot new if user is not owner' do
      @ability.can :create, Repository
      allow(controller).to receive(:own_repository?).and_return(false)
      allow(controller).to receive(:org_repository?).and_return(false)
      post :create, repository: { github_name: 'flyerhzm/test' }
      expect(response).to redirect_to([:new, :repository])
    end
  end

  context 'GET :edit' do
    it 'should assign repository' do
      @ability.can :edit, Repository
      get :edit, id: @repository.id
      expect(response).to be_ok
      expect(assigns(:repository)).to eq @repository
    end
  end

  context 'PUT :update' do
    it 'should redirecrt to edit page if update successfully' do
      @ability.can :update, Repository
      put :update, id: @repository.id, repository: { name: 'rails-brakeman.com' }
      expect(response).to redirect_to([:edit, @repository])
    end

    it 'should render edit page if update failed' do
      @ability.can :update, Repository
      allow_any_instance_of(Repository).to receive(:update_attributes).and_return(false)
      put :update, id: @repository.id, repository: { name: 'rails-brakeman.com' }
      expect(response).to render_template(:edit)
    end
  end

  context 'GET :show' do
    context 'without build' do
      it 'should redirect with id' do
        @ability.can :read, Repository
        get :show, id: @repository.id
        expect(response).to redirect_to('/flyerhzm/rails-brakeman.com')
      end

      it 'shoud assign repository with owner_name and repository_name' do
        create :build, repository: @repository, aasm_state: 'completed'

        @ability.can :read, Repository
        get :show, owner_name: 'flyerhzm', repository_name: 'rails-brakeman.com'
        expect(response).to be_ok
        expect(assigns(:repository)).not_to be_nil
      end

      it 'should render 404 if owner_name or repository_name does not exist' do
        get :show, owner_name: 'flyerhzm', repository_name: 'rails.com'
        expect(response).to be_not_found
        expect(assigns(:repository)).to be_nil
      end
    end

    context 'with build' do
      it 'should assign build' do
        create :build, repository: @repository, aasm_state: 'completed'

        @ability.can :read, Repository
        get :show, owner_name: @user.nickname, repository_name: @repository.name
        expect(response).to render_template('builds/show')
        expect(assigns(:build)).not_to be_nil
      end
    end

    context 'png' do
      it 'should send_file with badge' do
        create(:build, repository: @repository, aasm_state: 'completed')

        expect(controller).to receive(:send_file).with(
          Rails.root.join('public/images/passing.png'),
          type: 'image/png',
          disposition: 'inline'
        )
        allow(controller).to receive(:render)

        @ability.can :read, Repository
        get :badge, owner_name: @user.nickname, repository_name: @repository.name
      end
    end
  end

  context 'POST :sync' do
    let(:hook_json) { File.read(Rails.root.join('spec/fixtures/github_hook.json')) }
    let(:last_message) {
      {
        'id' => '473d12b3ca40a38f12620e31725922a9d88b5386',
        'url' => 'https://github.com/railsbp/rails-bestpractices.com/commit/473d12b3ca40a38f12620e31725922a9d88b5386',
        'author' => {
          'email' => 'flyerhzm@gmail.com',
          'name' => 'Richard Huang'
        },
        'message' => 'copy config yaml files for travis',
        'timestamp' => '2011-12-25T20:36:34+08:00'
      }
    }
    let!(:repository) { create(:repository, html_url: 'https://github.com/railsbp/rails-bestpractices.com') }

    it 'should generate build' do
      expect_any_instance_of(Repository).to receive(:generate_build).with('master', last_message)
      post :sync, token: '123456789', payload: hook_json, format: 'json'
      expect(response).to be_ok
      expect(response.body).to eq 'success'
    end

    it 'should not generate build if token is wrong' do
      post :sync, token: '987654321', payload: hook_json, format: 'json'
      expect(response).to be_ok
      expect(response.body).to eq 'not authenticate'
    end

    it 'should not generate build if url does not exist' do
      repository.update(html_url: 'https://github.com/railsbp/rails-brakeman.com')
      post :sync, token: '123456789', payload: hook_json, format: 'json'
      expect(response).to be_ok
      expect(response.body).to eq 'not authenticate'
    end

    it 'should not generate build if repository is private' do
      repository.update(private: true)
      post :sync, token: '123456789', payload: hook_json, format: 'json'
      expect(response).to be_ok
      expect(response.body).to eq 'no private repository'
    end

    it 'should not generate build if repository is not rails project' do
      repository.update(rails: false)
      post :sync, token: '123456789', payload: hook_json, format: 'json'
      expect(response).to be_ok
      expect(response.body).to eq 'not rails repository'
    end
  end
end
