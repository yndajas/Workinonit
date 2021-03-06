class UsersController < ApplicationController
    before_action :redirect_if_not_logged_in, except: [:new, :create]

    def new
    end

    def create
        raise params.inspect
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
end