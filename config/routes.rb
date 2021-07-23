Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: 'home#home'

  get '/infinite_scroll', to: 'infinite_scroll#show'
  get '/search', to: 'home#search'

  resources :notifications, only: %i(index)

  resources :relationships, only: %i(create destroy)

  resources :recipes do
    resource :favorites, only: %i(create destroy)
    resources :comments, only: %i(create destroy)
  end

  resources :users, only: %i(index show edit update) do
    get :followings, :followers, :comments, :favorites
  end
  get '/generate_username', to: 'users#generate_username'
end
