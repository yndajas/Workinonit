class JobsController < ApplicationController
    def new
        @countries = ProviderCountry.all
    end

    def create
        url = params[:job_url]

        raise params.inspect

        # if here from user providing URL on /jobs/new
        if url
            attributes = JobScraper.scrape_job_by_url(url)

            # if attributes variable is a string, process as an error message, else use to create job and redirect to show
            if attributes.is_a?(String)
                redirect_to new_job_path, flash: { notice: attributes }
            else
                job = Job.create_from_scraped_attributes(attributes)
                redirect_to job_path(job)
            end
        # if here from search results (save jobs)
        else
            attributes_hashes = JobScraper.scrape_jobs_by_id_hash(params[:job_ids])
            attributes_hashes.each {|attributes| Job.create_from_scraped_attributes(attributes)}
            redirect_to jobs_path
        end
    end
end