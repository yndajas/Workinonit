class SessionsController < ApplicationController
    before_action :logged_in_redirect, except: [:destroy]

    def new
    end

    def create
        if auth
            # OmniAuth
            user = User.where(email: auth[:info][:email]).first_or_create do |user|          
                user.password = SecureRandom.hex
                user.random_password = true
                user.provider = auth[:provider]
                user.uid = auth[:uid]
                user.name = auth[:info][:name]
            end
            session[:user_id] = user.id
            logged_in_redirect
        else
            # standard email/password login
            user = User.find_by(email: params[:email])
            if user.try(:authenticate, params[:password])
                session[:user_id] = user.id
                logged_in_redirect
            else
                redirect_to login_path, flash: {type: 'danger', content: "Incorrect email and/or password. Please try again."}
            end
        end
    end

    def destroy
        session.delete :user_id
        redirect_to login_path
    end

    private

    def auth
        @auth ||= request.env['omniauth.auth']
    end
end