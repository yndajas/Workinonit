class SessionsController < ApplicationController
    # login
    def new
        @user = User.new
    end

    def create
        # OmniAuth
        
        # TODO

        # standard email/password login
        user = User.find_by(email: params[:user][:email])
        if user.try(:authenticate, params[:user][:password])
            session[:user_id] = user.id
            redirect_to dashboard_path(user)
        else
            redirect_to login_path, flash: { notice: "Incorrect email and/or password. Please try again." }
        end
    end

    def destroy
        session.delete :user_id
    end
end