class JobsController < ApplicationController
    before_action :redirect_if_not_logged_in

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
                redirect_to job_path(job)
            end
        # if here from user manually entering job details on /jobs/new
        elsif params[:job]
            job = Job.find_or_create_by_attributes_hash_with_user(job_params, current_user)
            redirect_to job_path(job)
        # if here from search results (save jobs)
        else
            country_id = params[:country_id].to_i
            attributes_hashes = JobScraper.scrape_jobs_by_id_hash(params[:job_ids], country_id)
            attributes_hashes.each do |attributes|
                Job.find_or_create_by_attributes_hash_with_user(attributes, current_user)
            end
            redirect_to jobs_path
        end
    end

    def destroy
        UserJob.find(job_id: params[:id]).destroy
        Application.where(user_id: current_user.id, job_id: params[:id]).destroy_all
        redirect_to jobs_path
    end

    private

    def job_params
        params.require(:job).permit(:title, :company_name, :location, :salary, :contract, :description, :custom_url)
    end
end