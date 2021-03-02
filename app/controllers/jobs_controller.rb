class JobsController < ApplicationController
    def new
        @countries = ProviderCountry.all
    end

    def create
        url = params[:job_url]
        if url
            job = JobScraper::scrape_job_by_url(url)
            if job
                redirect_to job_path(job)
            else
                redirect_to new_job_path, flash: { notice: "URL not recognised. Only indeed.com, linkedin.com and reed.co.uk URLs are supported" }
            end
        else
            raise params.inspect
        end
    end
end