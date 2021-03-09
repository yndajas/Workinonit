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
            existing_application = Application.find_by_user_job(UserJob.find_by_user_and_job(current_user, @job))
            redirect_to application_path(existing_application), flash: {type: 'warning', content: "Application already exists"} if existing_application

            @application.job = @job
        # if here via /applications/new
        else
            @jobs = Job.find_by_user_and_unapplied_alphabetical(current_user)
        end

        @statuses = Status.all

        @progress_booleans = {checked_job_requirements: "Checked job requirements", researched_company: "Researched company", made_contact: "Made informal contact", prepared_cv: "Prepared CV or entered details online", prepared_cover_letter: "Prepared cover letter or personal statement"}
        @dates = {date_found: "Found job", date_applied: "Submitted application", interview_date: "Interview", date_outcome_received: "Received outcome"}    
    end

    def create
        application = current_user.applications.create(application_params)
        redirect_to application_path(application)
    end

    def show
        @application = Application.find(params[:id])
    end

    private

    def application_params
        params.require(:application).permit(:job_id, :status_id, :checked_job_requirements, :researched_company, :made_contact, :prepared_cv, :prepared_cover_letter, :date_found, :date_applied, :interview_date, :date_outcome_received, :notes, :feedback)
    end
end