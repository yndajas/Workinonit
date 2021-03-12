class FeedbackController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        @applications = Application.find_unsuccessful_by_user_without_feedback_alphabetical(current_user)
        redirect_to applications_path, flash: {type: 'warning', content: "No unsuccessful applications without feedback found"} if @applications.length == 0
    end

    def create
        @application = Application.find_by_id(feedback_params[:id])
        @application.update(feedback: feedback_params[:feedback])
        redirect_to feedback_path(@application)
    end

    def show
        @application = Application.find_by_id(params[:id])
        redirect_if_no_application_or_does_not_belong_to_user(feedback_index_path)
        redirect_if_no_feedback
    end

    def index
        # get filtered and ordered company/ies and feedback
        # if here from /companies/:id/:slug/feedback
        if params[:id]
            @company = Company.find_by_id(params[:id])
            
            if @company
                @applications_with_feedback = Application.find_by_user_and_company_reverse_by_date_with_feedback(current_user, @company, :updated_at)
                redirect_to company_path(@company), flash: {type: 'warning', content: "No saved feedback found from company"} if @applications_with_feedback.length == 0
            else
                redirect_to companies_path, flash: {type: 'warning', content: "Company not found"}
            end
        else
            @companies = current_user.companies_with_feedback_alphabetical
            @applications_with_feedback = Application.find_by_user_reverse_by_date_with_feedback(current_user, :updated_at)
        end

        # if here from /companies/:id/:slug/feedback, render special view (else default to regular index)
        if @applications_with_feedback.length > 0 && params[:id]
            @title = "Feedback from #{@company.name}"
            render 'filtered_index'
        end
    end

    def filter
        company = Company.find(params[:company_id])
        redirect_to company_feedback_path(company, company.slug)
    end

    def edit
        @application = Application.find_by_id(params[:id])
        redirect_if_no_application_or_does_not_belong_to_user(feedback_index_path)
    end

    def update
        application = Application.find_by_id(params[:id])
        application.update(feedback: feedback_params[:feedback])
        redirect_to feedback_path(application), flash: {type: 'success', content: "Feedback successfully updated"}
    end

    def destroy
        application = Application.find_by_id(params[:id])
        application.update(feedback: nil) if application.user == current_user
        redirect_to feedback_index_path, flash: {type: 'success', content: "Feedback successfully deleted"}
    end

    private

    def feedback_params
        params.require(:application).permit(:id, :feedback)
    end

    def redirect_if_no_feedback
        unless @application.has_value_for?(:feedback)
            redirect_to application_path(@application), flash: {type: 'warning', content: "Application has no feedback"}
        end
    end
end