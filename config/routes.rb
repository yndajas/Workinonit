Rails.application.routes.draw do
  root 'users#show'

  # sessions
  get 'login', to: 'sessions#new'
  resources :sessions, only: [:create]
  delete 'session', to: 'sessions#destroy'

  # OmniAuth
  get 'auth/facebook/callback', to: 'sessions#create'

  # users
  get 'register', to: 'users#new'
  get 'dashboard', to: 'users#show'
  get 'account', to: 'users#edit'
  resources :users, only: [:create, :update, :destroy]

  # jobs
  resources :jobs

  # search
  post 'jobs/search', to: 'search#create'
  get 'jobs/search/:country_code/:location/:keywords', to: 'search#show', constraints: {country_code: /[a-z]+/, location: /[a-z0-9\-]+/, keywords: /[a-z0-9\-]+/} # constraints so it only matches with country codes of lower case letters, and locations and keywords of lower case letters, numbers and hyphens

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
