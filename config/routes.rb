Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :users
  resources :recipes do
    resource :favorites, only: [:create, :destroy]
  end
  post '/home/guest_sign_in', to: 'home#guest_sign_in'
end
