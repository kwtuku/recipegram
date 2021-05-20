Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: "home#index"

  resources :users do
    get :followings, :followers
  end
  resources :relationships, only: [:create, :destroy]

  resources :recipes do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  get '/show_additionally', to: 'recipes#show_additionally'
end
