Rails.application.routes.draw do
  resources :musicians, only: [:index, :show]
end
