Rails.application.routes.draw do
  resources :subscriptions
  devise_for :users

  root to: "events#index"

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
  end

  resources :users, only: %i[show edit update create]
end
