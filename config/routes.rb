Rails.application.routes.draw do
  resources :musicians do
    resources :releases, only: [:show, :new, :create, :edit, :update]
  end
end
