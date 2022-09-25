Rails.application.routes.draw do
  devise_for :users

  root to: "events#index"

  resources :events do
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: %i[show edit update create]
end
