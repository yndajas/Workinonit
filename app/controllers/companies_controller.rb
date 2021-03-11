class CompaniesController < ApplicationController
    before_action :redirect_if_not_logged_in

    def show
        @company = Company.find_by_id(params[:id])
        redirect_to companies_path, flash: {type: 'warning', content: "Company not found"} if !@company

        user_jobs = UserJob.find_by_user_and_company_reverse_by_date(current_user, @company, :created_at)
        @jobs = user_jobs.collect { |user_job| user_job.job }
        @applications = Application.find_by_user_and_company_reverse_by_date(current_user, @company, :updated_at)
        @applications_with_feedback = Application.find_by_user_and_company_reverse_by_date_with_feedback(current_user, @company, :updated_at)    
    end

    def filter
        redirect_to self.send("company_#{params[:filter]}_path", params[:id], params[:slug])
    end

    def index
        companies = current_user.companies_alphabetical

        @companies_with_stats = companies.collect do |company|
            job_count = UserJob.find_by_user_and_company_reverse_by_date(current_user, company, :created_at).length
            application_count = Application.find_by_user_and_company_reverse_by_date(current_user, company, :updated_at).length
            feedback_count = Application.find_by_user_and_company_reverse_by_date_with_feedback(current_user, company, :updated_at).length            
            {company: company, job_count: job_count, application_count: application_count, feedback_count: feedback_count}
        end
    end

    def edit
        @company = Company.find_by_id(params[:id])
        redirect_to companies_path, flash: {type: 'warning', content: "Company not found"} if !@company
        @user_company_information = UserCompanyInformation.find_or_initialize_by(user_id: current_user.id, company_id: @company.id)
        render 'new' if @user_company_information.new_record?
    end

    def update
        company = Company.find_by_id(params[:id])
        
        user_company_information = UserCompanyInformation.find_or_initialize_by(user_id: current_user.id, company_id: company.id)

        flash_end = user_company_information.new_record? ? "added" : "updated"

        user_company_information.assign_attributes(user_company_information_params)
        user_company_information.save

        redirect_to company_path(company, company.slug), flash: {type: 'success', content: "Company information #{flash_end}"}
    end

    def destroy
        company = Company.find_by_id(params[:id])
        UserCompanyInformation.find_by(user_id: current_user.id, company_id: company.id).destroy
        redirect_to company_path(company.id, company.slug), flash: {type: 'success', content: "Company information deleted"}
    end

    private

    def user_company_information_params
        params.require(:user_company_information).permit(:website, :notes)
    end
end