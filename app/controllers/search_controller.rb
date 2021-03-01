class SearchController < ApplicationController
    def create        
        keywords = Slugifiable::slugify(params[:search][:keywords])
        location = Slugifiable::slugify(params[:search][:location])
        country_code = params[:search][:country_code]
        
        redirect_to jobs_search_path(country_code, location, keywords)
    end
    
    def show

    end
end