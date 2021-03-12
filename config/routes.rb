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
  post 'jobs/filter', to: 'jobs#filter', as: 'filtered_jobs'
  get 'jobs/unapplied', to: 'jobs#index', as: 'unapplied_jobs'

  # jobs/applications
  get 'jobs/:id/:slug/apply', to: 'applications#new', as: 'new_application_by_job'

  # applications
  resources :applications
  post 'applications/filter', to: 'applications#filter', as: 'filtered_applications'
  get 'applications/status/:slug', to: 'applications#index', as: 'applications_by_status'

  # feedback

  resources :feedback, only: [:new, :index, :create]
  get 'applications/:id/feedback', to: 'feedback#show', as: 'feedback'
  get 'applications/:id/feedback/edit', to: 'feedback#edit', as: 'edit_feedback'
  patch 'applications/:id/feedback', to: 'feedback#update'
  delete 'applications/:id/feedback', to: 'feedback#destroy'
  post 'feedback/filter', to: 'feedback#filter', as: 'filtered_feedback'

  # companies
  resources :companies, only: [:index]
  get 'companies/:id/:slug', to: 'companies#show', as: 'company'
  # the following actually interact with the CompanyInformation model
  get 'companies/:id/:slug/edit', to: 'companies#edit', as: 'edit_company'
  patch 'companies/:id/:slug', to: 'companies#update'
  delete 'companies/:id/:slug', to: 'companies#destroy'
  post 'companies/:id/:slug/filter', to: 'companies#filter', as: 'filtered_companies'  

  # companies nested routes/resources
  get 'companies/:id/:slug/jobs', to: 'jobs#index', as: 'company_jobs'
  get 'companies/:id/:slug/applications', to: 'applications#index', as: 'company_applications'
  get 'companies/:id/:slug/feedback', to: 'feedback#index', as: 'company_feedback'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
