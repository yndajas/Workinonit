class FeedbackController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        @applications = Application.find_by_user_without_feedback_alphabetical(current_user)
    end

    def create
        @application = Application.find(params[:id])
        @application.feedback = params[:feedback]
        @application.save
        redirect_to feedback_path(@application)
    end

    def show
        @application = Application.find(params[:id])
        redirect_if_no_application_or_does_not_belong_to_user
    end

    def index
        # get filtered and ordered company/ies and feedback
        # if here from /companies/:id/:slug/feedback
        if params[:id]
            @company = Company.find_by_id(params[:id])
            
            if @company
                @applications = Application.find_by_user_and_company_reverse_by_date_with_feedback(current_user, @company, :updated_at)
                redirect_to company_path(@company), flash: {type: 'warning', content: "No saved feedback found from company"} if @applications.length == 0
            else
                redirect_to companies_path, flash: {type: 'warning', content: "Company not found"}
            end
        else
            @companies = current_user.companies_with_feedback_alphabetical
            @applications = Application.find_by_user_reverse_by_date_with_feedback(current_user, :updated_at)
        end

        # if here from /companies/:id/:slug/feedback, render special view (else default to regular index)
        if @applications.length > 0 && params[:id]
            @title = "Feedback from #{@company.name}"
            render 'filtered_index'
        end
    end

    def filter
        company = Company.find(params[:company_id])
        redirect_to company_feedback_path(company, company.slug)
    end

    private

    def redirect_if_no_application_or_does_not_belong_to_user
        unless @application.try(:user).try(:==, current_user)
            redirect_to feedback_index_path, flash: {type: 'warning', content: "Application not found"}
        end
    end
end