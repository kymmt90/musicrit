Rails.application.routes.draw do
  root to: 'musicians#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :genres
  resources :musicians do
    resources :releases do
      resources :reviews, module: :releases, only: [:new, :create, :edit, :update, :destroy]
      resources :tracks, only: [:show]
    end
    resources :reviews, module: :musicians, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :users, only: [] do
    resources :reviews, module: :users, only: [:index]
  end
end
