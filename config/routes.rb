Rails.application.routes.draw do
  root 'users#show'

  # sessions
  get 'login' => 'sessions#new'
  resources :sessions, only: [:create]
  delete 'session' => 'sessions#destroy'

  # OmniAuth
  get 'auth/facebook/callback', to: 'sessions#create'

  # users
  get 'register' => 'users#new'
  get 'dashboard' => 'users#show'
  get 'account' => 'users#edit'
  resources :users, only: [:create, :update, :destroy]

  # jobs
  resources :jobs

  # search - add constraints? -> constraints: { id: /[A-Z][A-Z][0-9]+/ }
  post 'jobs/search' => 'search#create'
  get 'jobs/search/:country_code/:location/:keywords' => 'search#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
