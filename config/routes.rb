Rails.application.routes.draw do
  resources :musicians do
    resources :releases
  end
end
