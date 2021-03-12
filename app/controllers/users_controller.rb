class UsersController < ApplicationController
    before_action :redirect_if_not_logged_in, except: [:new, :create]

    def new
    end

    def create
        if User.find_by(email: user_create_params[:email])
            redirect_to login_path, flash: {type: 'warning', content: "User with email #{user_create_params[:email]} already exists. Try logging in"}
        else
            user = User.create(user_create_params)
            session[:user_id] = user.id
            redirect_to dashboard_path, flash: {type: 'success', content: "Account created. Time to get Workinonit!"}
        end        
    end

    def show
        @job_count = UserJob.user(current_user).length
        @open_applications_count = Application.find_by_user_and_open_reverse_by_date(current_user, :updated_at).length
        @jobs_without_applications_count = Job.find_by_user_and_unapplied_alphabetical(current_user).length
        @feedback_count = Application.find_by_user_reverse_by_date_with_feedback(current_user, :updated_at).length
        @applications_awaiting_feedback_count = Application.find_unsuccessful_by_user_without_feedback_alphabetical(current_user).length
    end

    def edit
    end

    def update
        if user_update_params[:name]
            current_user.update(name: user_update_params[:name])
            redirect_to account_path, flash: {type: 'success', content: "Name successfully updated"}
        elsif !user_update_params[:current_password] || current_user.authenticate(user_update_params[:current_password])
            if user_update_params[:new_email]
                if User.find_by(email: user_update_params[:new_email])
                    redirect_to account_path, flash: {type: 'warning', content: "Account with email #{user_update_params[:new_email]} already exists"}
                else
                    current_user.update(email: user_update_params[:new_email])
                    redirect_to account_path, flash: {type: 'success', content: "Email successfully updated"}
                end
            else
                current_user.update(password: user_update_params[:new_password], random_password: false)
                redirect_to account_path, flash: {type: 'success', content: "Password successfully updated"}
            end
        else
            redirect_to account_path, flash: {type: 'danger', content: "Incorrect password"}
        end
    end

    def destroy
        current_user.jobs.each do |job|
            job.destroy if job.user_generated?
        end

        [:applications, :user_company_information, :user_jobs].each do |collection|
            current_user.send(collection).destroy_all
        end

        current_user.destroy
        session.delete :user_id
        redirect_to login_path, flash: {type: 'success', content: "Account successfully deleted"}
    end

    private

    def user_create_params
        params.permit(:name, :email, :password)
    end

    def user_update_params
        params.require(:user).permit(:name, :email, :new_email, :new_password, :current_password)
    end
end