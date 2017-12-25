Rails.application.routes.draw do
  resources :musicians do
    resources :releases do
      resources :tracks, only: [:show]
    end
  end
end
