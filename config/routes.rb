Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :users do
    get :followings, :followers
  end
  resources :recipes do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
  post '/home/guest_sign_in', to: 'home#guest_sign_in'
end
