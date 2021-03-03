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
        @jobs = JobScraper::scrape_search(params[:keywords], params[:location], @country_id)
    end
end