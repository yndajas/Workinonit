class UsersController < ApplicationController
    before_action :redirect_if_not_logged_in, only: [:show]

    # get 'register' => 'users#new'
    # get 'account' => 'users#edit'
    # resources :users, only: [:create, :update, :destroy]

    def show
    end
end