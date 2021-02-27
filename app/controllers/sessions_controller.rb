class SessionsController < ApplicationController
    # login
    def new
        @user = User.new
    end

    def create
        # OmniAuth
        
        # TODO

        # standard email/password login
        user = User.find_by(email: params[:email])
        if user.try(:authenticate, params[:password])
            session[:user_id] = user.id
            redirect_to dashboard_path(user)
        else
            redirect_to login_path, flash: { message: "Incorrect email and/or password. Please try again." }
        end
    end

    def destroy
        session.delete :user_id
    end
end