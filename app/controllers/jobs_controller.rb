class JobsController < ApplicationController
    before_action :redirect_if_not_logged_in, except: [:show]

    def new
        @countries = ProviderCountry.all
        @job = Job.new
    end

    def create
        # if here from user providing URL on /jobs/new
        if params[:job_url]
            attributes_or_error = JobScraper.scrape_job_by_url(params[:job_url])

            # if attributes_or_error variable is a string, process as an error message, else use to create job (and associate with current user) and redirect to show
            if attributes_or_error.is_a?(String)
                redirect_to new_job_path, flash: {type: 'danger', content: attributes_or_error}
            else
                job = Job.find_or_create_by_attributes_hash_with_user(attributes_or_error, current_user)
                redirect_to job_path(job, job.slug)
            end

        # if here from user manually entering job details on /jobs/new
        elsif params[:job]
            @job = Job.find_or_create_by_attributes_hash_with_user(job_params, current_user)
            if @job.valid?
                redirect_to job_path(@job, @job.slug)
            else
                @countries = ProviderCountry.all
                flash.now[:type] = 'danger'
                flash.now[:content] = "Cannot save job without title and company"
                render 'new'
            end
        
        # if here from search results (save jobs) on /jobs/search/:country_code/:location/:keywords
        elsif params[:job_ids]
            country_id = params[:country_id].to_i
            attributes_hashes = JobScraper.scrape_jobs_by_id_hash(params[:job_ids], country_id)
            attributes_hashes.each do |attributes|
                Job.find_or_create_by_attributes_hash_with_user(attributes, current_user)
            end
            redirect_to jobs_path
        
        # if here from job show page (for a job the user hasn't saved to their account) on /jobs/:id/:slug
        else
            job = UserJob.create(user_id: current_user.id, job_id: params[:job_id]).job
            redirect_to job_path(job, job.slug)
        end
    end

    def show
        @job = Job.find_by_id(params[:id])

        # if job exists, check if it's user generated
        if @job
            @user_generated = @job.user_generated?

            # if user-generated, get the associated user job and format and sanitize description
            if @user_generated
                redirect_if_not_logged_in
                @user_job = UserJob.find_by_job(@job)
                @description = @job.format_and_sanitize(:description)
            else
                @description = @job.sanitize(:description)
            end
        end

        # if the job exists and it's from a provider (not user generated) or generated by the current user
        if @job && (!@user_generated || @user_job.try(:user) == current_user)
            # if logged in and @user_job is not already set, find it; look for an application if a user job was found here or above
            if logged_in?
                @user_job = UserJob.find_by_user_and_job(current_user, @job) if !@user_job
                @application = Application.find_by_user_job(@user_job) if @user_job
            end
            @salary_and_contract = {salary: {has_value: @job.has_value_for?(:salary), label: "MuNNY:"}, contract: {has_value: @job.has_value_for?(:contract), label: "Contract:"}}
        else
            redirect_to jobs_path, flash: {type: 'warning', content: "Job not found"}
        end
    end

    def index
        # get filtered and ordered company/ies and user jobs
        # if here from /companies/:id/:slug/jobs
        if params[:id]
            @company = Company.find_by_id(params[:id])
            
            if @company
                user_jobs = UserJob.find_by_user_and_company_reverse_by_date(current_user, @company, :created_at)
                redirect_to companies_path, flash: {type: 'warning', content: "No saved jobs found at company"} if user_jobs.length == 0
            else
                redirect_to companies_path, flash: {type: 'warning', content: "Company not found"}
            end
        # if here from /jobs/unapplied        
        elsif request.path.downcase == "/jobs/unapplied"
            user_jobs = UserJob.find_by_user_and_unapplied_reverse_by_date(current_user, :created_at)
            redirect_to jobs_path, flash: {type: 'warning', content: "No saved jobs without applications"} if user_jobs.length == 0
        # if here from /jobs
        else
            @companies = current_user.companies_alphabetical
            user_jobs = UserJob.find_by_user_reverse_by_date(current_user, :created_at)
        end

        # get jobs and applications associated with the user jobs
        @job_activities = user_jobs.collect do |user_job|
            user_job_saved_at = user_job.created_at
            job = user_job.job
            application = Application.find_by_user_job(user_job)
            
            {user_job_saved_at: user_job_saved_at, job: job, application: application}
        end

        # if here from /companies/:id/:slug/jobs or /jobs/unapplied, render special view (else default to regular index)
        # added second check on user_jobs length here even though there are conditional redirects based on this above as Rails complains about calling render/redirect too many times when there are no user jobs
        if user_jobs.length > 0 && (params[:id] || request.path.downcase == "/jobs/unapplied")
            @title = (params[:id] ? "Jobs at #{@company.name}" : "Jobs without applications")
            render 'filtered_index'
        end
    end

    def filter
        if params[:company_id]
            company = Company.find(params[:company_id])
            redirect_to company_jobs_path(company, company.slug)
        else
            if params[:status] == "Application started"
                redirect_to applications_path
            else
                redirect_to unapplied_jobs_path
            end
        end
    end

    def edit
        @job = Job.find_by_id(params[:id])

        if @job.user_generated?
            # if user generated but not by current user (else pass through to normal edit action behaviour)
            if UserJob.find_by_job(@job).user != current_user
                redirect_to jobs_path, flash: {type: 'warning', content: "Job not found"}
            end
        # if provider-based job
        else
            redirect_to job_path(@job, @job.slug), flash: {type: 'warning', content: "You cannot edit this job"}
        end
    end

    def update
        job = Job.find_by_id(params[:id])
        job.update(job_params)
        redirect_to job_path(job, job.slug), flash: {type: 'success', content: "Job successfully updated"}
    end

    def destroy
        user_job = UserJob.find_by_user_and_job(current_user, Job.find(params[:id]))
        job = user_job.job

        user_job.application.try(:destroy)
        user_job.destroy
        job.destroy if job.user_generated?
        
        redirect_to jobs_path, flash: {type: 'success', content: "Job successfully deleted"}
    end

    private

    def job_params
        params.require(:job).permit(:title, :company_name, :location, :salary, :contract, :description, :custom_url)
    end
end