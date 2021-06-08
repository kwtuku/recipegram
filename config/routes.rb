Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: "home#home"

  get  "/search", to: "home#search"

  resources :notifications, only: %i(index)

  resources :relationships, only: %i(create destroy)

  resources :recipes do
    resource :favorites, only: %i(create destroy)
    resources :comments, only: %i(create destroy)
  end
  get '/show_additionally', to: 'recipes#show_additionally'

  resources :users do
    get :followings, :followers
  end
end
