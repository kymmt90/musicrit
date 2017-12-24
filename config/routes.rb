Rails.application.routes.draw do
  resources :musicians do
    resources :releases, only: [:show]
  end
end
