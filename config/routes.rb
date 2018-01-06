Rails.application.routes.draw do
  root to: 'musicians#index'

  resources :genres, only: [:index, :show, :new]
  resources :musicians do
    resources :releases do
      resources :tracks, only: [:show]
    end
  end
end
