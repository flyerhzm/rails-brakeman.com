RailsBrakemanCom::Application.routes.draw do
  post '/' => 'repositories#sync'
  root to: "home#index"
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" } do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  resources :repositories, only: [:show, :new, :create, :edit, :update] do
    resources :builds, only: [:show, :index]
  end

  constraints user_name: /[^\/]+/, repository_name: /[^\/]+/ do
    get ":user_name/:repository_name", to: "repositories#show"
  end
end
