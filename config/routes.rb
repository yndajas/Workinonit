Rails.application.routes.draw do
  root 'users#show'

  # sessions
  get 'login', to: 'sessions#new'
  resources :sessions, only: [:create]
  delete 'session', to: 'sessions#destroy'

  # OmniAuth
  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/github/callback', to: 'sessions#create'
  get 'auth/google_oauth2/callback', to: 'sessions#create'

  # users
  get 'register', to: 'users#new'
  get 'dashboard', to: 'users#show'
  get 'account', to: 'users#edit'
  resources :users, only: [:create, :update, :destroy]

  # search
  scope '/jobs' do
    get 'search/:country_code/:location/:keywords', to: 'search#show', as: 'jobs_search', constraints: {country_code: /[a-z]+/, location: /[a-z0-9\-]+/, keywords: /[a-z0-9\-]+/} # constraints so it only matches with country codes of lower case letters, and locations and keywords of lower case letters, numbers and hyphens
    post 'search', to: 'search#create', as: 'jobs_searches'
  end
  
  # jobs
  resources :jobs


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
