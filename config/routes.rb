Rails.application.routes.draw do
  resources :musicians, only: [:index, :show, :new, :create]
end
