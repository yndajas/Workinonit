class JobsController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        @countries = ProviderCountry.all
    end

    def create
        country_id = params[:country_id]
        url = params[:job_url]

        # if here from user providing URL on /jobs/new
        if url
            attributes = JobScraper.scrape_job_by_url(url)

            # if attributes variable is a string, process as an error message, else use to create job (and associate with current user) and redirect to show
            if attributes.is_a?(String)
                redirect_to new_job_path, flash: { notice: attributes }
            else
                job = Job.find_or_create_by_scraped_attributes_with_user(attributes, current_user)
                redirect_to job_path(job)
            end
        # if here from search results (save jobs)
        else
            attributes_hashes = JobScraper.scrape_jobs_by_id_hash(params[:job_ids], country_id)
            attributes_hashes.each do |attributes|
                Job.find_or_create_by_scraped_attributes_with_user(attributes, current_user)
            end
            redirect_to jobs_path
        end
    end
end