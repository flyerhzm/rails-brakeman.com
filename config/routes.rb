RailsBrakemanCom::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  post '/' => 'repositories#sync'
  get 'pages/:action', controller: :pages
  root to: "home#index"
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  resources :repositories, only: [:show, :new, :create, :edit, :update] do
    resources :builds, only: [:show, :index] do
      member do
        get :analyze_file
      end
    end
  end

  constraints owner_name: /[^\/]+/, repository_name: /[^\/]+/ do
    get ":owner_name/:repository_name.png", to: "repositories#badge", as: :user_repo_badge
    get ":owner_name/:repository_name", to: "repositories#show", as: :user_repo
    get ":owner_name/:repository_name/builds", to: "builds#index", as: :user_repo_builds
    get ":owner_name/:repository_name/builds/:id", to: "builds#show", as: :user_repo_build
  end
end
