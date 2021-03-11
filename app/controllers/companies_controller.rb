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

    end

    def update

    end

    def destroy

    end

# the following actually interact with the CompanyInformation model
# get 'companies/:id/:slug/edit', to: 'companies#edit', as: 'edit_company'
# patch 'companies/:id/:slug', to: 'companies#update'
# delete 'companies/:id/:slug', to: 'companies#destroy'

end