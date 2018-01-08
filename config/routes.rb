Rails.application.routes.draw do
  devise_for :users
  root to: 'musicians#index'

  resources :genres
  resources :musicians do
    resources :releases do
      resources :tracks, only: [:show]
    end
  end
end
