class SessionsController < ApplicationController
    def new
    end

    def create
        if auth
            # OmniAuth
            user = User.where(email: auth[:info][:email]).first_or_create do |user|          
                user.password = SecureRandom.hex
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
                redirect_to login_path, flash: { notice: "Incorrect email and/or password. Please try again." }
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

    def logged_in_redirect
        # if user was redirected to login via another route, return to that route
        if session[:origin]
            origin = session[:origin]
            session.delete :origin
            redirect_to origin
        # if they came to login route normally, go to dashboard
        else
            redirect_to dashboard_path
        end
    end
end