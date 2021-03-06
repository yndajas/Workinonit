class UsersController < ApplicationController
    before_action :redirect_if_not_logged_in, except: [:new, :create]

    def new
    end

    def create
        if User.find_by(email: user_params[:email])
            redirect_to login_path, flash: {type: 'warning', content: "User with email #{user_params[:email]} already exists. Try logging in"}
        else
            user = User.create(user_params)
            session[:user_id] = user.id
            redirect_to dashboard_path, flash: {type: 'success', content: "Account created. Time to get Workinonit!"}
        end        
    end

    def show
    end

    def edit
    end

    def destroy
        [Application, UserCompanyInformation, UserJob].each do |cclass|
            cclass.where(user_id: current_user.id).destroy_all
        end

        current_user.destroy
        session.delete :user_id
        redirect_to login_path
    end

    private

    def user_params
        params.permit(:name, :email, :password)
    end
end