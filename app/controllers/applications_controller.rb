class ApplicationsController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        @application = Application.new

        # if here via /jobs/:id/:slug/apply
        if params[:id]
            # look for job in current user's jobs
            @job = current_user.jobs.find_by_id(params[:id])
            
            # redirect if job not found
            redirect_to jobs_path, flash: {type: 'warning', content: "Job not found"} if !@job

            # redirect if an application for the job (by the current user) already exists 
            user_job = UserJob.find_by_user_and_job(current_user, @job)
            existing_application = Application.find_by_user_job(user_job)
            redirect_to application_path(existing_application), flash: {type: 'warning', content: "Application already exists"} if existing_application
        # if here via /applications/new
        else
            @jobs = Job.find_by_user_and_unapplied_alphabetical(current_user)
        end

        set_progress_and_dates_instance_variables                
        set_statuses
    end

    def create
        application = current_user.applications.create(application_params)
        redirect_to application_path(application)
    end

    def show
        @application = Application.find_by_id(params[:id])
        redirect_if_no_application_or_does_not_belong_to_user(applications_path)

        set_progress_and_dates_instance_variables
    end

    def index
        # get filtered and ordered company/ies and applications
        # if here from /companies/:id/:slug/applications
        if params[:id]
            @company = Company.find_by_id(params[:id])
            
            if @company
                @applications = Application.find_by_user_and_company_reverse_by_date(current_user, @company, :updated_at)
                redirect_to company_path(@company), flash: {type: 'warning', content: "No saved applications found for company"} if @applications.length == 0
            else
                redirect_to companies_path, flash: {type: 'warning', content: "Company not found"}
            end
        # if here from /applications/status/:slug
        elsif status_filter_request?
            slug = status_filter_slug
            @status = Status.find_by_slug(slug)
            @applications = Application.find_by_user_and_status_reverse_by_date(current_user, @status, :updated_at)
            redirect_to applications_path, flash: {type: 'warning', content: "No saved applications with status \"#{@status.name.downcase}\""} if @applications.length == 0
        # if here from /applications
        else
            @companies = current_user.companies_with_applications_alphabetical
            @statuses = Status.all
            @applications = Application.find_by_user_reverse_by_date(current_user, :updated_at)
        end

        # if here from /companies/:id/:slug/applications or /applications/status/:slug, render special view (else default to regular index)
        if @applications.length > 0 && (params[:id] || status_filter_request?)
            @title = (params[:id] ? "Applications for #{@company.name}" : "Applications: #{@status.name.downcase}")
            render 'filtered_index'
        end
    end

    def filter
        if params[:company_id]
            company = Company.find_by_id(params[:company_id])
            redirect_to company_applications_path(company, company.slug)
        else
            status = Status.find_by_id(params[:status_id])
            redirect_to applications_by_status_path(status.slug)
        end
    end

    def edit
        @application = Application.find_by_id(params[:id])
        redirect_if_no_application_or_does_not_belong_to_user(applications_path)

        @job = @application.job
        set_progress_and_dates_instance_variables
        set_statuses
    end

    def update
        application = Application.find_by_id(params[:id])
        application.update(application_params)
        redirect_to application_path(application), flash: {type: 'success', content: "Application successfully updated"}
    end

    def destroy
        application = Application.find_by_id(params[:id])
        application.destroy if application.user == current_user
        redirect_to applications_path, flash: {type: 'success', content: "Application successfully deleted"}
    end

    private

    def application_params
        params.require(:application).permit(:job_id, :status_id, :checked_job_requirements, :researched_company, :made_contact, :prepared_cv, :prepared_cover_letter, :date_found, :date_applied, :interview_date, :date_outcome_received, :notes, :feedback)
    end

    def status_filter_request?
        !!(request.path.downcase =~ /\/applications\/status\/.+/)
    end

    def status_filter_slug
        request.path.downcase.gsub("/applications/status/", "")
    end

    def set_progress_and_dates_instance_variables
        @progress_booleans = {checked_job_requirements: "Checked job requirements", researched_company: "Researched company", made_contact: "Made informal contact", prepared_cv: "Prepared CV or entered details online", prepared_cover_letter: "Prepared cover letter or personal statement"}
        @dates = {date_found: "Found job", date_applied: "Submitted application", interview_date: "Interview", date_outcome_received: "Received outcome"}
    end

    def set_statuses
        @statuses = Status.all
    end
end