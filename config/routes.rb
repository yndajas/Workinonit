Rails.application.routes.draw do
  # static
  root 'static#home'
  get 'about', to: 'static#about'

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

  # searches
  scope '/jobs' do
    get 'search/:country_code/:location/:keywords', to: 'searches#show', as: 'jobs_search', constraints: {country_code: /[a-z]+/, location: /[a-z0-9\-]+/, keywords: /[a-z0-9\-]+/} # constraints so it only matches with country codes of lower case letters, and locations and keywords of lower case letters, numbers and hyphens
    post 'searches', to: 'searches#create', as: 'jobs_searches'
  end
  
  # jobs
  resources :jobs, only: [:new, :create, :index]
  get 'jobs/:id/:slug', to: 'jobs#show', as: 'job'
  get 'jobs/:id/:slug/edit', to: 'jobs#edit', as: 'edit_job'
  patch 'jobs/:id/:slug', to: 'jobs#update'
  delete 'jobs/:id/:slug', to: 'jobs#destroy'
  post '/jobs/filter', to: 'jobs#filter', as: 'filtered_jobs'

  # jobs/applications
  get 'jobs/:id/:slug/apply', to: 'applications#new',as: 'new_application_by_job'

  # applications
  resources :applications

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
