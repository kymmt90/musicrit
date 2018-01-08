Rails.application.routes.draw do
  root to: 'musicians#index'

  devise_for :users

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :genres
  resources :musicians do
    resources :releases do
      resources :tracks, only: [:show]
    end
  end
end
