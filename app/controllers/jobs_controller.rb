class JobsController < ApplicationController
    def new
        @countries = ProviderCountry.all
    end

    def create
        url = params[:job_url]
        if url
            job = JobScraper::scrape_job_by_url(url)

            # if job is a string, process as an error message, else it should be a Job instance so redirect to the show page
            if job.is_a?(String)
                redirect_to new_job_path, flash: { notice: job }
            else
                redirect_to job_path(job)
            end
        else
            raise params.inspect
        end
    end
end