Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get 'users/confirm_destroy', to: 'users/registrations#confirm_destroy'
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: 'home#home'

  get '/privacy', to: 'home#privacy'
  get '/search', to: 'home#search'

  resources :notifications, only: %i[index]

  resources :tags, only: %i[index show], param: :name do
    resource :followers, only: %i[create destroy], controller: 'tags/followers'
  end

  resources :relationships, only: %i[create destroy]

  resources :recipes do
    resource :favorites, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end

  resources :users, param: :username, only: %i[index show update] do
    get :followings, :followers, :comments, :favorites
    resources :following_tags, only: %i[index], controller: 'users/following_tags'
  end
  resource :users, only: %i[edit], path_names: { edit: 'edit/profile' }
  get '/generate_username', to: 'users#generate_username'
end
