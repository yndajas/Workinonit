class SearchController < ApplicationController
    before_action :redirect_if_not_logged_in

    def create        
        keywords = Slugifiable::slugify(params[:search][:keywords])
        location = Slugifiable::slugify(params[:search][:location])
        country_code = params[:search][:country_code]
        
        redirect_to jobs_search_path(country_code, location, keywords)
    end
    
    def show
        @country_id = ProviderCountry.find_by(code: params[:country_code]).country_id
        @jobs = JobScraper.scrape_search(params[:keywords], params[:location], @country_id)
        
        @provider_search_urls = {}
        @jobs.each do |provider, jobs|
            if jobs.length > 0
                arguments = [params[:keywords], params[:location]]
                arguments << @country_id if provider == :Indeed
                @provider_search_urls[provider] = JobScraper.send("#{provider.downcase}_search_url", *arguments)
            end
        end
    end
end